From: Keith Busch <keith.busch@intel.com>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
 support optional
Date: Mon, 8 Feb 2016 16:15:59 +0000
Message-ID: <20160208161559.GC25111@localhost.localdomain>
References: <1454783624.2809.6.camel@HansenPartnership.com>
 <20160207092241.GA15331@lst.de>
 <1454861040.2329.4.camel@HansenPartnership.com>
 <56B7C527.6050300@kernel.dk>
 <1454886441.2329.27.camel@HansenPartnership.com>
 <56B8448A.3000106@suse.de>
 <56B8676C.20600@dev.mellanox.co.il>
 <20160208101350.GA32632@lst.de>
 <20160208151258.GB25111@localhost.localdomain>
 <56B8B1F1.4070605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B8B1F1.4070605@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@dev.mellanox.co.il>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 08, 2016 at 04:19:13PM +0100, Hannes Reinecke wrote:
> Ok, so what about having a 'wwid' attribute which provides combined
> information (like scsi has)?

That looks like the sensible thing to do. Thanks for pointer.

Going forward, I will solicite more feedback from scsi developers
so NVMe's external attributes better align with storage that already
solved our issues. I agree with Christoph that we never should have
relied on SCSI translations for NVMe, but we don't want to reinvent
generic solutions either.
