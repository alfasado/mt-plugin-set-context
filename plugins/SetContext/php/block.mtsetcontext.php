<?php
function smarty_block_mtsetcontext( $args, $content, $ctx, &$repeat ) {
    if (! isset( $content ) ) {
        $ctx->stash( 'orig_blog', $ctx->stash( 'blog' ) );
        $ctx->stash( 'orig_category', $ctx->stash( 'category' ) );
        $ctx->stash( 'orig_entry', $ctx->stash( 'entry' ) );
        $ctx->stash( 'orig_author', $ctx->stash( 'author' ) );
        $ctx->stash( 'orig_current_timestamp', $ctx->stash( 'current_timestamp' ) );
        $ctx->stash( 'orig_current_timestamp_end', $ctx->stash( 'current_timestamp_end' ) );
        if ( isset( $args[ 'blog_id' ] ) ) {
            $blog = $ctx->mt->db()->fetch_blog( $args[ 'blog_id' ] );
            $ctx->stash( 'blog', $blog );
            $ctx->stash( 'blog_id', $args[ 'blog_id' ] );
        }
        if ( isset( $args[ 'blog_id' ] ) ) {
            $blog = $ctx->mt->db()->fetch_blog( $args[ 'blog_id' ] );
            $ctx->stash( 'blog', $blog );
            $ctx->stash( 'blog_id', $args[ 'blog_id' ] );
        }
        if ( isset( $args[ 'author_id' ] ) ) {
            $author = $ctx->mt->db()->fetch_author( $args[ 'author_id' ] );
            $ctx->stash( 'author', $author );
        }
        if ( isset( $args[ 'author_id' ] ) ) {
            $author = $ctx->mt->db()->fetch_author( $args[ 'author_id' ] );
            $ctx->stash( 'author', $author );
        }
        if ( isset( $args[ 'author' ] ) ) {
            $author = $ctx->mt->db()->fetch_author_by_name( $args[ 'author' ] );
            $ctx->stash( 'author', $author );
        }
        if ( isset( $args[ 'category_id' ] ) ) {
            $category = $ctx->mt->db()->fetch_category( $args[ 'category_id' ] );
            $ctx->stash( 'category', $category );
        }
        require_once( 'MTUtil.php' );
        if ( isset( $args[ 'include_blogs' ] ) or isset( $args[ 'exclude_blogs' ] ) ) {
            $blog_ctx_arg = isset( $args[ 'include_blogs' ] ) ?
                array( 'include_blogs' => $args[ 'include_blogs' ] ) :
                array( 'exclude_blogs' => $args[ 'exclude_blogs' ] );
        }
        if ( isset( $args[ 'category' ] ) ) {
            $category = cat_path_to_category( $args[ 'category' ], $blog_ctx_arg, 'category' );
            if (! empty( $category ) ) {
                if ( is_array( $category ) ) {
                    $category = $category[ 0 ];
                    $ctx->stash( 'category', $category );
                }
            }
        }
        if ( isset( $args[ 'folder' ] ) ) {
            $category = cat_path_to_category( $args[ 'folder' ], $blog_ctx_arg, 'folder' );
            if (! empty( $category ) ) {
                if ( is_array( $category ) ) {
                    $category = $category[ 0 ];
                    $ctx->stash( 'category', $category );
                }
            }
        }
        if ( isset( $args[ 'entry_id' ] ) ) {
            $entry = $ctx->mt->db()->fetch_entry( $args[ 'entry_id' ] );
            $ctx->stash( 'entry', $entry );
        }
        if ( isset( $args[ 'current_timestamp' ] ) ) {
            $ctx->stash( 'current_timestamp', $args[ 'current_timestamp' ] );
        }
        if ( isset( $args[ 'current_timestamp_end' ] ) ) {
            $ctx->stash( 'current_timestamp_end', $args[ 'current_timestamp_end' ] );
        }
    } else {
        $ctx->stash( 'blog', $ctx->stash( 'orig_blog' ) );
        $ctx->stash( 'category', $ctx->stash( 'orig_category' ) );
        $ctx->stash( 'entry', $ctx->stash( 'orig_entry' ) );
        $ctx->stash( 'author', $ctx->stash( 'orig_author' ) );
        $ctx->stash( 'current_timestamp', $ctx->stash( 'orig_current_timestamp' ) );
        $ctx->stash( 'current_timestamp_end', $ctx->stash( 'orig_current_timestamp_end' ) );
        $repeat = FALSE;
    }
    return $content;
}
?>