<?php
function smarty_block_mtclearcontext( $args, $content, $ctx, &$repeat ) {
    if (! isset( $content ) ) {
        $ctx->stash( 'orig_blog', $ctx->stash( 'blog' ) );
        $ctx->stash( 'orig_category', $ctx->stash( 'category' ) );
        $ctx->stash( 'orig_entry', $ctx->stash( 'entry' ) );
        $ctx->stash( 'orig_author', $ctx->stash( 'author' ) );
        $ctx->stash( 'orig_current_timestamp', $ctx->stash( 'current_timestamp' ) );
        $ctx->stash( 'orig_current_timestamp_end', $ctx->stash( 'current_timestamp_end' ) );
        $ctx->stash( 'author', NULL );
        $ctx->stash( 'category', NULL );
        $ctx->stash( 'entry', NULL );
        $ctx->stash( 'current_timestamp', NULL );
        $ctx->stash( 'current_timestamp_end', NULL );
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