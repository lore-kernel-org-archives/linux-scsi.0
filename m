From: Age Strand <aages@imr.no>
Subject: Re: aix79xx driver status
Date: Thu, 22 Sep 2005 10:36:29 +0200
Message-ID: <1127378189.26581.52.camel@itse6863.imr.no>
References: <0D54094F69391A438650C6151B0A33E402132A7A@post2.imr.no>
	 <20050921132934.GA32696@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.imr.no ([82.134.28.194]:12337 "EHLO ns.imr.no")
	by vger.kernel.org with ESMTP id S1751452AbVIVIge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 04:36:34 -0400
Received: from post2.imr.no ([10.1.2.137])
	by ns.imr.no with esmtp (Exim 4.43)
	id 1EIMZC-0000YF-Ff
	for linux-scsi@vger.kernel.org; Thu, 22 Sep 2005 10:36:30 +0200
In-Reply-To: <20050921132934.GA32696@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 2005-09-21 at 14:29 +0100, Christoph Hellwig wrote:
> On Wed, Sep 21, 2005 at 11:44:28AM +0200, Strand ?ge wrote:
> > 
> > Hi,
> > 
> > I'm trying to debug an md RAID problem and was looking into aic79xx driver version, and now I'm confused.
> > 
> > The 2.6.13 kernel code lists the version for this driver as 1.3.11 (AIC79XX_DRIVER_VERSION), and it looks like the last update was back in 2003.
> > 
> > But I can find a 2.0.14 version of the driver at adaptec.com, dated 17.May 2005:
> > http://www.adaptec.com/worldwide/support/driversbycat.jsp?sess=no&language=English+US&cat=%2FOperating+System%2FLinux+Driver+Source+Code
> > 
> > Granted, it says the driver is "minimally tested", but I wonder why the aic79xx driver in the kernel hasn't been updated since 2003 when there are newer versions being developed by the vendor.
> > 
> > Is there a fork in the aic79xx driver tree? What was the reason? Is there any point in even trying the "minimally tested" driver from adaptec, or is that to be considered dangerous?
> 
> Yes, there was a fork.  The kernel aic79xx got various fixes and got
> integerated better with the scsi subsytem, using generic, fully debugged
> code instead of it's own, etc..  Unfortunately there's also various fixes
> in the adaptec releases which need to be brought back.  They are sometimes
> non-trivial and until a short time ago non of the core SCSI developers
> had aic79xx hardware.  The fixes will be merged back one day, similar
> to the aic7xxx where this happened.

As far as I understand you the aic7Yxx kernel driver tree is very much
alive and kicking.

So what's the deal with the version numbers on the aic79xx driver? It
has stayed put on 1.1.13 since 2003. Does that mean that there hasn't
been any new releases of this driver since then? 

I seem to recall seeing submitted patches to aic79xx on the list as late
as 2004. What's become of those? Is this just a case of patches going in
but version numbering not being updated?

Regarding lack of hardware for developers: Are you looking for hardware
donors (e.g. of 39320 cards), and would that aid development on the
aic79xx driver?


Best regards,
aage

