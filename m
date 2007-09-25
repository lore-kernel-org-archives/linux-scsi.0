From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 6/9] mpt fusion: error recovery
	improvements,andsynchronizing internal commands
Date: Tue, 25 Sep 2007 17:57:18 -0500
Message-ID: <1190761038.8707.11.camel@localhost.localdomain>
References: <664A4EBB07F29743873A87CF62C26D709D940E@NAMAIL4.ad.lsil.com>
	 <46F95586.2020504@garzik.org>  <46F98DDB.8070407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56113 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751486AbXIYW5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 18:57:21 -0400
In-Reply-To: <46F98DDB.8070407@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Jeff Garzik <jeff@garzik.org>, "Moore, Eric" <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org

On Tue, 2007-09-25 at 17:38 -0500, Michael Reed wrote:
> Jeff Garzik wrote:
> > Moore, Eric wrote:
> >> On Tuesday, September 25, 2007 11:32 AM,  James Bottomley  wrote:
> >>  
> >>>> Youve rejected the error recovery patchs, which is fair enough.  
> >>> Just the separation ... the actual patch looks OK.
> >>>
> >>
> >> I'll will continue working to separate the "error recovery
> >> improvements:" into smaller feature add, but will take some time.   I
> >> want some constructive feedback, and too big of patch is deterring some
> >> people from looking at it.
> > 
> > I think it's fair to break it up, as long as its clearly noted that the
> > patch is for review only.
> 
> Any chance the changes, properly documented, could be accepted as
> one big patch?  Breaking this code into smaller patches, when it's
> really intended as a driver update, could prove problematic.

Yes, that's OK ... separate patches with signoffs are not absolute
requirements as long as the description and the heritage is in the
change log (although if you can do it, I prefer the separate signoffs
and distinct patches).

James


