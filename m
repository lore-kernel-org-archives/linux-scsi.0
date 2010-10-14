From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] tcm: Unify INQUIRY subsystem plugin handling
Date: Thu, 14 Oct 2010 11:26:01 +0200
Message-ID: <20101014092601.GB28446@lst.de>
References: <1286959681-3445-1-git-send-email-nab@linux-iscsi.org> <20101013110653.GA26366@lst.de> <1287001189.7334.47.camel@haakon2.linux-iscsi.org> <20101014000421.GB15583@lst.de> <1287030937.9909.30.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1287030937.9909.30.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 13, 2010 at 09:35:37PM -0700, Nicholas A. Bellinger wrote:
> So you would rather have struct se_device attributes set in TCM
> subsystem specific ->create_virtdevice() code directly after
> transport_add_device_to_core_hba() -> se_dev_set_default_attribs(),
> right..?

Actually you would want to set them before
transport_add_device_to_core_hba.  Always make sure an object is fully
set up before making it accessible.
