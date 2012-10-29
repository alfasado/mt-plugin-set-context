package SetContext::Tags;

use strict;

sub _hdlr_set_context {
    my ( $ctx, $args, $cond ) = @_;
    require MT::Blog;
    my $blog = $ctx->stash( 'blog' );
    my $orig_blog = $blog;
    my $orig_category = $ctx->stash( 'category' );
    my $orig_entry = $ctx->stash( 'entry' );
    my $orig_author = $ctx->stash( 'author' );
    my $orig_current_timestamp = $ctx->{ current_timestamp };
    my $orig_current_timestamp_end = $ctx->{ current_timestamp_end };
    if ( my $blog_id = $args->{ blog_id } ) {
        $blog = MT::Blog->load( $blog_id );
        $ctx->{ __stash }{ blog } = $blog;
        $ctx->{ __stash }{ blog_id } = $blog->id;
        $args->{ blog_id } = $blog->id;
    }
    my ( %blog_terms, %blog_args );
    $ctx->set_blog_load_context( $args, \%blog_terms, \%blog_args )
        or return $ctx->error( $ctx->errstr );
    if ( my $author_id = $args->{ author_id } ) {
        require MT::Author;
        my $author = MT::Author->load( $author_id );
        $ctx->{ __stash }{ author } = $author;
    }
    if ( my $author = $args->{ author } ) {
        require MT::Author;
        my $author = MT::Author->load( { name => $author } );
        $ctx->{ __stash }{ author } = $author;
    }
    if ( my $entry_id = $args->{ entry_id } ) {
        require MT::Entry;
        my $entry = MT::Entry->load( $entry_id );
        $ctx->{ __stash }{ entry } = $entry;
        if ( $blog->id != $entry->blog_id ) {
            $ctx->{ __stash }{ blog } = $entry->blog;
            $ctx->{ __stash }{ blog_id } = $entry->blog_id;
        }
    }
    if ( my $category_id = $args->{ category_id } ) {
        require MT::Category;
        my $category = MT::Category->load( $category_id );
        $ctx->{ __stash }{ category } = $category;
        $ctx->{ __stash }{ archive_category } = $category;
        if ( $blog->id != $category->blog_id ) {
            $ctx->{ __stash }{ blog } = MT::Blog->load( $category->blog_id );
            $ctx->{ __stash }{ blog_id } = $category->blog_id;
        }
    }
    if ( my $category_arg = $args->{ category } ) {
        my $category = $ctx->cat_path_to_category( $category_arg,
            [ \%blog_terms, \%blog_args ], 'category' );
        $ctx->{ __stash }{ category } = $category;
        $ctx->{ __stash }{ archive_category } = $category;
        if ( $blog->id != $category->blog_id ) {
            $ctx->{ __stash }{ blog } = MT::Blog->load( $category->blog_id );
            $ctx->{ __stash }{ blog_id } = $category->blog_id;
        }
    }
    if ( my $category_arg = $args->{ folder } ) {
        my $category = $ctx->cat_path_to_category( $category_arg,
            [ \%blog_terms, \%blog_args ], 'folder' );
        $ctx->{ __stash }{ category } = $category;
        $ctx->{ __stash }{ archive_category } = $category;
        if ( $blog->id != $category->blog_id ) {
            $ctx->{ __stash }{ blog } = MT::Blog->load( $category->blog_id );
            $ctx->{ __stash }{ blog_id } = $category->blog_id;
        }
    }
    if ( my $current_timestamp = $args->{ current_timestamp } ) {
        $ctx->{ current_timestamp }= $current_timestamp;
    }
    if ( my $current_timestamp_end = $args->{ current_timestamp_end } ) {
        $ctx->{ current_timestamp_end }= $current_timestamp_end;
    }
    my $html = $ctx->stash( 'builder' )->build( $ctx, $ctx->stash( 'tokens' ), $cond );
    $ctx->{ __stash }{ blog } = $orig_blog;
    $ctx->{ __stash }{ category } = $orig_category;
    $ctx->{ __stash }{ archive_category } = $orig_category;
    $ctx->{ __stash }{ entry } = $orig_entry;
    $ctx->{ __stash }{ author } = $orig_author;
    $ctx->{ current_timestamp } = $orig_current_timestamp;
    $ctx->{ current_timestamp_end } = $orig_current_timestamp_end;
    return $html;
}

sub _hdlr_clear_context {
    my ( $ctx, $args, $cond ) = @_;
    my $orig_category = $ctx->stash( 'category' );
    my $orig_entry = $ctx->stash( 'entry' );
    my $orig_author = $ctx->stash( 'author' );
    my $orig_current_timestamp = $ctx->{ current_timestamp };
    my $orig_current_timestamp_end = $ctx->{ current_timestamp_end };
    my @keys = qw/ category archive_category entry author /;
    for my $stash ( @keys ) {
        $ctx->{ __stash }{ $stash } = undef;
    }
    $ctx->{ current_timestamp }= undef;
    $ctx->{ current_timestamp_end }= undef;
    my $html = $ctx->stash( 'builder' )->build( $ctx, $ctx->stash( 'tokens' ), $cond );
    $ctx->{ __stash }{ category } = $orig_category;
    $ctx->{ __stash }{ archive_category } = $orig_category;
    $ctx->{ __stash }{ entry } = $orig_entry;
    $ctx->{ __stash }{ author } = $orig_author;
    $ctx->{ current_timestamp } = $orig_current_timestamp;
    $ctx->{ current_timestamp_end } = $orig_current_timestamp_end;
    return $html;
}

1;