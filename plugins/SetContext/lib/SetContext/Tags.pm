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
    my $tokens = $ctx->stash( 'tokens' );
    my $builder = $ctx->stash( 'builder' );
    require MT::Template::Context;
    $ctx = MT::Template::Context->new;
    if ( my $blog_id = $args->{ blog_id } ) {
        $blog = MT::Blog->load( $blog_id );
        $ctx->stash( 'blog', $blog );
        $ctx->stash( 'blog_id', $blog->id );
        $args->{ blog_id } = $blog->id;
    }
    my ( %blog_terms, %blog_args );
    $ctx->set_blog_load_context( $args, \%blog_terms, \%blog_args )
        or return $ctx->error( $ctx->errstr );
    if ( my $author_id = $args->{ author_id } ) {
        require MT::Author;
        my $author = MT::Author->load( $author_id );
        $ctx->stash( 'author', $author );
    }
    if ( my $author_name = $args->{ author } ) {
        require MT::Author;
        my $author = MT::Author->load( { name => $author_name } );
        $ctx->stash( 'author', $author );
    }
    if ( my $entry_id = $args->{ entry_id } ) {
        require MT::Entry;
        my $entry = MT::Entry->load( $entry_id );
        $ctx->stash( 'entry', $entry );
        if ( $blog->id != $entry->blog_id ) {
            $ctx->stash( 'blog', $entry->blog );
            $ctx->stash( 'blog_id', $entry->blog->id );
        }
    }
    if ( my $category_id = $args->{ category_id } ) {
        require MT::Category;
        my $category = MT::Category->load( $category_id );
        $ctx->stash( 'category', $category );
        $ctx->stash( 'archive_category', $category );
        if ( $blog->id != $category->blog_id ) {
            $ctx->stash( 'blog', MT::Blog->load( $category->blog_id ) );
            $ctx->stash( 'blog_id', $category->blog_id );
        }
    }
    if ( my $category_arg = $args->{ category } ) {
        my @cats = $ctx->cat_path_to_category( $category_arg,
            [ \%blog_terms, \%blog_args ], 'category' );
        if ( @cats ) {
            my $category = $cats[ 0 ];
            $ctx->stash( 'category', $category );
            $ctx->stash( 'archive_category', $category );
            if ( $blog->id != $category->blog_id ) {
                $ctx->stash( 'blog', MT::Blog->load( $category->blog_id ) );
                $ctx->stash( 'blog_id', $category->blog_id );
            }
        }
    }
    if ( my $category_arg = $args->{ folder } ) {
        my @cats = $ctx->cat_path_to_category( $category_arg,
            [ \%blog_terms, \%blog_args ], 'category' );
        if ( @cats ) {
            my $category = $cats[ 0 ];
            $ctx->stash( 'category', $category );
            $ctx->stash( 'archive_category', $category );
            if ( $blog->id != $category->blog_id ) {
                $ctx->stash( 'blog', MT::Blog->load( $category->blog_id ) );
                $ctx->stash( 'blog_id', $category->blog_id );
            }
        }
    }
    if ( my $current_timestamp = $args->{ current_timestamp } ) {
        $ctx->{ current_timestamp }= $current_timestamp;
    }
    if ( my $current_timestamp_end = $args->{ current_timestamp_end } ) {
        $ctx->{ current_timestamp_end }= $current_timestamp_end;
    }
    my $html = $builder->build( $ctx, $tokens, $cond );
    $ctx->stash( 'blog', $orig_blog );
    $ctx->stash( 'category', $orig_category );
    $ctx->stash( 'archive_category', $orig_category );
    $ctx->stash( 'entry', $orig_entry );
    $ctx->stash( 'author', $orig_author );
    $ctx->{ current_timestamp } = $orig_current_timestamp;
    $ctx->{ current_timestamp_end } = $orig_current_timestamp_end;
    return $html;
}

sub _hdlr_clear_context {
    my ( $ctx, $args, $cond ) = @_;
    my $tokens = $ctx->stash( 'tokens' );
    my $builder = $ctx->stash( 'builder' );
    require MT::Template::Context;
    $ctx = MT::Template::Context->new;
    my $html = $builder->build( $ctx, $tokens, $cond );
    return $html;
}

1;