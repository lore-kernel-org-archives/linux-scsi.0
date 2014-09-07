From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] scsi-lib: implement init_flush_rq and its pair
Date: Sun, 7 Sep 2014 20:53:38 +0200
Message-ID: <20140907185338.GD23026@lst.de>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com> <1410079162-9872-6-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410079162-9872-6-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

> +static int __scsi_init_request(struct request *rq, int numa_node)

Nitpick: Please use a sane name here, e.g. scsi_mq_alloc/free_sense_buffer.
