From: Matthew Wilcox <willy@debian.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Wed, 19 Nov 2003 23:18:05 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119231805.GG30485@parcelfarce.linux.theplanet.co.uk>
References: <B179AE41C1147041AA1121F44614F0B060ED75@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:39072 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264163AbTKSXSH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 18:18:07 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED75@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jeremy@sgi.com, jbarnes@sgi.com

On Wed, Nov 19, 2003 at 03:03:09PM -0800, Andrew Vasquez wrote:
> > I suggest doing something similar for all architectures that do not
> > provide x86 BIOS emulation.
> 
> I don't believe this is going to be a safe route.  QLogic does offer
> other methods to modify NVRAM parameters besides the BIOS utility, a
> GUI (SANsurfer) as well as a command-line tool (SANblade CLI) - the
> 64bit versions are available here:
> 
> 	http://www.qlogic.com/support/os_detail.asp?productid=256&osid=65

Where are the PA-RISC versions?  Where are the Alpha versions?  Where are
the Sparc versions?  This just isn't a workable solution for many people.
PCI cards really are supposed to work on all architectures.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
