From: "Freels, James D." <freelsjd@ornl.gov>
Subject: Re: [Bug 8366] aic79xx and aic7xxx driver issues
Date: Thu, 26 Jul 2007 17:52:17 -0400
Message-ID: <1185486737.14419.73.camel@fea.ornl.gov>
References: <20070725010525.614621080E4@picon.linux-foundation.org>
 <1185329683.3488.46.camel@localhost.localdomain>
 <1185461780.14419.17.camel@fea.ornl.gov>
 <1185462341.3501.62.camel@localhost.localdomain>
 <1185480022.14419.58.camel@fea.ornl.gov>
 <1185482804.3501.87.camel@localhost.localdomain>
 <1185484390.3501.93.camel@localhost.localdomain>
 <1185484597.14419.65.camel@fea.ornl.gov>
 <1185485358.3501.94.camel@localhost.localdomain>
 <1185485848.14419.71.camel@fea.ornl.gov>
 <1185486264.3501.99.camel@localhost.localdomain>
Reply-To: freelsjd@ornl.gov
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emroute2.ornl.gov ([160.91.86.17]:45672 "EHLO emroute2.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932552AbXGZVwT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 17:52:19 -0400
Received: from emroute2.ornl.gov ([127.0.0.1])
 by emroute2.ornl.gov (PMDF V6.3-x11 #31501)
 with ESMTP id <0JLT009453F6YE@emroute2.ornl.gov> for
 linux-scsi@vger.kernel.org; Thu, 26 Jul 2007 17:52:18 -0400 (EDT)
In-reply-to: <1185486264.3501.99.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Thanks James.  It patched this time, compiled, and is now rebooting.  I
have a backup running tonight at 1am.  I will report back in.

This would be great if it fixes it.  I also have another similar bug
with the aic79xx driver on another machine (see my other bug reports).
I wonder if this will fix it also ?

On Thu, 2007-07-26 at 17:44 -0400, James Bottomley wrote:
> On Thu, 2007-07-26 at 17:37 -0400, Freels, James D. wrote:
> > Here is what I get when I apply the patch against the vanilla 2.6.22.1
> > source:
> 
> The reject files all have spaces instead of tabs, so it looks like your
> mailer did some nefarious translation.
> 
> Try the attachment ... that usually defeats mailer text translations.
> 
> the md5sum just for integrity's sake is 9ba6ace80c06d34b5391407ea68c381a
> 
> I tested it against 2.6.22.1 and it applies (but with some offsets):
> 
> jejb@hobholes> quilt push
> Applying patch tmp.diff
> patching file drivers/scsi/aic7xxx/aic79xx_osm.c
> Hunk #1 succeeded at 2309 (offset 25 lines).
> Hunk #2 succeeded at 2393 (offset 25 lines).
> Hunk #3 succeeded at 2475 (offset 25 lines).
> Hunk #4 succeeded at 2515 (offset 25 lines).
> Hunk #5 succeeded at 2551 (offset 25 lines).
> Hunk #6 succeeded at 2595 (offset 25 lines).
> Hunk #7 succeeded at 2631 (offset 25 lines).
> Hunk #8 succeeded at 2675 (offset 25 lines).
> patching file drivers/scsi/aic7xxx/aic7xxx_osm.c
> Hunk #1 succeeded at 2356 (offset 39 lines).
> Hunk #2 succeeded at 2425 (offset 39 lines).
> 
> James
> 
James D. Freels, Ph.D.
Senior Research Staff, HFIR Cold Source, ORNL
http://sunsite.utk.edu/wuot/mt/podcast/051807HIFER.mp3
