From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] show "Fusion MPT device support" menu only if BLK _DEV_SD
Date: Wed, 21 Jan 2004 18:01:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040121180154.A32424@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E5703A75F51@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703A75F51@exa-atlanta.se.lsil.com>; from Emoore@lsil.com on Wed, Jan 21, 2004 at 12:00:09PM -0500
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Adrian Bunk <bunk@fs.tum.de>, Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 21, 2004 at 12:00:09PM -0500, Moore, Eric Dean wrote:
> The "config FUSION" entry in Kconfig is handling both mptbase.ko 
> and mptscsih.ko for some reason?
> 
> The mptbase.ko driver is the lower layer driver which configures
> the adapters and is transport layer to and from the chip. It doesn't
> depend on anything in the scsi mid layer.  
> 
> The mptscsih.ko does depend on scsi_mod.ko, but not sd.ko  
> 
> Therefore - maybe we could have separate entries in Kconfig for
> both mptbase and mptscsih.  mptbase depend on PCI, and mptscsih
> depend on SCSI. What do you think?

Sounds good.  (And mptscsi should depend on mptbase of course)
