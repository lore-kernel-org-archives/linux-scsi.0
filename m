From: Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: adp94xx driver for 2.6.13?
Date: Wed, 31 Aug 2005 17:38:00 -0700
Message-ID: <20050901003800.GA3666@localhost.localdomain>
References: <20050831053318.GA3556@localhost.localdomain> <1125518912.4617.41.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from serv01.siteground.net ([70.85.91.68]:41358 "EHLO
	serv01.siteground.net") by vger.kernel.org with ESMTP
	id S965008AbVIAAh3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 20:37:29 -0400
Content-Disposition: inline
In-Reply-To: <1125518912.4617.41.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Aug 31, 2005 at 04:08:32PM -0400, James Bottomley wrote:
> On Tue, 2005-08-30 at 22:33 -0700, Ravikiran G Thirumalai wrote:
> > Are drivers/sources available for Adaptec's AIC-94XX SAS controllers
> > someplace?  I am trying to run 2.6.13 on a x460.  Any pointers to the latest
> > driver sources appreciated.
> 
> There is no driver source for Adaptec SATA hardware.  You need to get
> the latest binary drivers from Adaptec support.

Someone from adaptec had posted the sources to linux-scsi some time back, but
unfortunately, it is a humongous 27 patch patchset, with some malformed
patches. Also one of the patches is missing (#6 ,or the patch numbering 
was bad). So I was wondering if folks from adaptec or other people stuck with
this adapter could point me to the sources, if it is available...

Thanks,
Kiran
