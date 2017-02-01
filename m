From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH] scsi, block: fix duplicate bdi name registration
        crashes
Date: Wed, 1 Feb 2017 09:08:01 +0100
Message-ID: <20170201080801.GB29170@lst.de>
References: <148566590827.1627.3631056985359212959.stgit@dwillia2-desk3.amr.corp.intel.com> <20170130122452.GA9043@lst.de> <CAPcyv4j2zm93jp6j7__xhSTXWKnh2MdEr5BxJ_ycku77xdtrTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4j2zm93jp6j7__xhSTXWKnh2MdEr5BxJ_ycku77xdtrTQ@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@osandov.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 30, 2017 at 12:57:05PM -0800, Dan Williams wrote:
> 
> struct kref {
>         atomic_t refcount;
> };
> 
> ...so what do we gain by open coding kref_get() and kref_put()?

A much less ugly calling convention.
