From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [patch 0/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:17:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41596458.2080600@adaptec.com>
References: <4159611C.4030106@adaptec.com> <20040928131151.GV16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:12752 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267786AbUI1NRU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:17:20 -0400
In-Reply-To: <20040928131151.GV16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Matthew Wilcox wrote:
> On Tue, Sep 28, 2004 at 09:03:24AM -0400, Luben Tuikov wrote:
>  > config SCSI_AIC79XX
>  >       tristate "Adaptec AIC79xx U320 support"
>  > -     depends on PCI && SCSI
>  > +     depends on PCI
> 
> Wrong.  This allows modular SCSI and non-modular AIC79xx.  That's just daft
> and can't possibly work.  Put the depend back.

Yes, I agree.  The depend is in.

I just needed a "base" from which to start to apply
the patches, so I needed to submit a patch which
makes the driver look like it was 1.5 years ago,
so that the rest of the patches from our SCM apply.

The "end" version of this depend  is as it is in the
kernel "depends on PCI && SCSI".

	Luben

