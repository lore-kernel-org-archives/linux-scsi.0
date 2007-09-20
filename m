From: "Mukker, Atul" <Atul.Mukker@lsi.com>
Subject: RE: kdump detection in SCSI drivers
Date: Thu, 20 Sep 2007 11:47:46 -0600
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501B2C7D8@NAMAIL1.ad.lsil.com>
References: <9738BCBE884FDB42801FAD8A7769C26501B2C44C@NAMAIL1.ad.lsil.com> <20070920104249.GB12157@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42185 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbXITRsH convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 13:48:07 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070920104249.GB12157@atrey.karlin.mff.cuni.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

How do we "know" when little memory is available?

Other suggestion which came about was to parse the kernel command line
and look for "elfcorehdr=". Is this ok? Is kernel command line visible
to the SCSI drivers?

Thanks
-Atul

-----Original Message-----
From: Pavel Machek [mailto:pavel@ucw.cz] 
Sent: Thursday, September 20, 2007 6:43 AM
To: Mukker, Atul
Cc: Linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: kdump detection in SCSI drivers

> Hi,
> 
> Is there a standard way for drivers (RAID) to detect if the current
> kernel is running in kdump mode? We would like to adjust driver
behavior
> dynamically when kdump is active by scaling down resources.

Perhaps you should be automatically using little resources when little
memory is available, or something? 

With upcomping kjump patches, it is more "interesting" than kdump
vs. no kdump.
	
Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
