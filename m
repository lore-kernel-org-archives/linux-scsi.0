From: Matthew Wilcox <willy@debian.org>
Subject: Re: advansys driver vs 2.6 breakage
Date: Thu, 7 Aug 2003 12:21:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030807112157.GF22222@parcelfarce.linux.theplanet.co.uk>
References: <200308070422.41412.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:52393 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S275200AbTHGLV7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 07:21:59 -0400
Content-Disposition: inline
In-Reply-To: <200308070422.41412.gene.heskett@verizon.net>
List-Id: linux-scsi@vger.kernel.org
To: Gene Heskett <gene.heskett@verizon.net>
Cc: bfrey@turbolinux.com.cn, linux-scsi@vger.kernel.org, Janitors <kernel-janitor-discuss@lists.sourceforge.net>

On Thu, Aug 07, 2003 at 04:22:41AM -0400, Gene Heskett wrote:
> This is, FWIW, not the only code that is apparently broken by that 
> ioports.h header redefinition.
> 
> I'm getting messages from other modules squawking about the 
> __deprecated status of "check_region" during the compile too.

This seems to be a fundamental misunderstanding on your part.

check_region is not broken.  It is deprecated.  That means we asked the
compiler to emit a warning when someone tries to use it.  It does not
mean that it will crash.

Something else is going on here, and someone with one of these cards
needs to debug it properly.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
