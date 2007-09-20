From: Pavel Machek <pavel@ucw.cz>
Subject: Re: kdump detection in SCSI drivers
Date: Thu, 20 Sep 2007 12:42:49 +0200
Message-ID: <20070920104249.GB12157@atrey.karlin.mff.cuni.cz>
References: <9738BCBE884FDB42801FAD8A7769C26501B2C44C@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57772 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXITKmu (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 06:42:50 -0400
Content-Disposition: inline
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501B2C44C@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: Linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> Hi,
> 
> Is there a standard way for drivers (RAID) to detect if the current
> kernel is running in kdump mode? We would like to adjust driver behavior
> dynamically when kdump is active by scaling down resources.

Perhaps you should be automatically using little resources when little
memory is available, or something? 

With upcomping kjump patches, it is more "interesting" than kdump
vs. no kdump.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
