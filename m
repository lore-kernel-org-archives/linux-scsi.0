From: Christoph Hellwig <hch@infradead.org>
Subject: Re: aix79xx driver status
Date: Wed, 21 Sep 2005 14:29:34 +0100
Message-ID: <20050921132934.GA32696@infradead.org>
References: <0D54094F69391A438650C6151B0A33E402132A7A@post2.imr.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7600 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750914AbVIUN3f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2005 09:29:35 -0400
Content-Disposition: inline
In-Reply-To: <0D54094F69391A438650C6151B0A33E402132A7A@post2.imr.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Strand ?ge <aage.strand@imr.no>
Cc: linux-scsi@vger.kernel.org

On Wed, Sep 21, 2005 at 11:44:28AM +0200, Strand ?ge wrote:
> 
> Hi,
> 
> I'm trying to debug an md RAID problem and was looking into aic79xx driver version, and now I'm confused.
> 
> The 2.6.13 kernel code lists the version for this driver as 1.3.11 (AIC79XX_DRIVER_VERSION), and it looks like the last update was back in 2003.
> 
> But I can find a 2.0.14 version of the driver at adaptec.com, dated 17.May 2005:
> http://www.adaptec.com/worldwide/support/driversbycat.jsp?sess=no&language=English+US&cat=%2FOperating+System%2FLinux+Driver+Source+Code
> 
> Granted, it says the driver is "minimally tested", but I wonder why the aic79xx driver in the kernel hasn't been updated since 2003 when there are newer versions being developed by the vendor.
> 
> Is there a fork in the aic79xx driver tree? What was the reason? Is there any point in even trying the "minimally tested" driver from adaptec, or is that to be considered dangerous?

Yes, there was a fork.  The kernel aic79xx got various fixes and got
integerated better with the scsi subsytem, using generic, fully debugged
code instead of it's own, etc..  Unfortunately there's also various fixes
in the adaptec releases which need to be brought back.  They are sometimes
non-trivial and until a short time ago non of the core SCSI developers
had aic79xx hardware.  The fixes will be merged back one day, similar
to the aic7xxx where this happened.

