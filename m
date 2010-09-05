From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC 22/22] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
 module
Date: Sun, 5 Sep 2010 13:30:06 -0700
Message-ID: <20100905203006.GD18411@core.coreip.homeip.net>
References: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1283160203-6981-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 30, 2010 at 02:23:23AM -0700, Nicholas A. Bellinger wrote:
> +
> +static void tcm_loop_primary_release(struct device *dev)
> +{
> +	return;
> +}
> +
> +static struct device tcm_loop_primary = {
> +	.init_name		= "tcm_loop_0",
> +	.release		= tcm_loop_primary_release,
> +};
> +

No, you can not have statically allocated devices and dummy release
functions.

-- 
Dmitry
