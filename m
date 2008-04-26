From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: AIC94xx SAS question.
Date: Sat, 26 Apr 2008 10:56:50 -0400
Message-ID: <20080426145649.GA8848@animx.eu.org>
References: <20080421231940.GB5656@animx.eu.org> <4812B66A.5000105@hopnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:42873 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbYDZO4x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2008 10:56:53 -0400
Received: from wakko by animx.eu.org with local
	(Exim 4.64 #1 (Debian Bug?  What bug /\oo/\))
	id 1Jplpa-0002Uu-2v
	for linux-scsi@vger.kernel.org; Sat, 26 Apr 2008 10:56:50 -0400
Content-Disposition: inline
In-Reply-To: <4812B66A.5000105@hopnet.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Keith Hopkins wrote:
> On 04/22/2008 07:19 AM, Wakko Warner wrote:
> >Can either of these be done:
> >1) Embed the firmware into the driver so that it can be used before the
> >rootfs id mounted.
> 
> I think this is generally not done because firmware tends to be 
> closed-source.

I can understand this from the point of the distrobution of the linux
kernel, but it still can be done.  If there were a patch or something that
would convert the file, that's all I care.  This for me would be preferred.

> >2) Can the firmware be loaded in an initr{d,amfs}?
> 
> Sure.  openSuSE does it in their mkinitrd.

I'm not sure if you got the point of #2 or not.  I do *NOT* want the driver
as a module, I want it compiled into the kernel and then load the firmware
from an initramfs.

I think I figured out how to do #2, but if/when I do it is another story.  I
believe that the driver won't bind to the card if the firmware isn't
available, thus I can have it bind to the card at a later time (during
initramfs).  I tried this on my system last night (since it crashed anyway). 
I loaded the module and /sys wasn't mounted.  I mounted /sys and told the
driver to bind my card and it worked.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
