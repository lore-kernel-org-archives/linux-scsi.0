From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] virtio_scsi: support multi hw queue of blk-mq
Date: Mon, 10 Nov 2014 11:41:43 +0100
Message-ID: <54609667.8030702@redhat.com>
References: <1415552224-31145-1-git-send-email-ming.lei@canonical.com> <1415552224-31145-3-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48058 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaKJKlt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 05:41:49 -0500
Received: by mail-wi0-f180.google.com with SMTP id hi2so9926273wib.13
        for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2014 02:41:48 -0800 (PST)
In-Reply-To: <1415552224-31145-3-git-send-email-ming.lei@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>, James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On 09/11/2014 17:57, Ming Lei wrote:
> Since virtio_scsi has supported multi virtqueue already,
> it is natural to map virtque to hw-queue of blk-mq.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/scsi/virtio_scsi.c |  154 ++++----------------------------------------
>  1 file changed, 14 insertions(+), 140 deletions(-)

Nice. :)

FWIW, instead of force_blk_mq, it would be fine for me to make
virtio-scsi use a single queue if not using blk-mq.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
