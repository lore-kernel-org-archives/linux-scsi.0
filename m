From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Fix up qla2xxx configuration bogosity
Date: Thu, 28 Jul 2005 11:58:59 -0700
Message-ID: <20050728185859.GC567@plap.qlogic.org>
References: <20050728051058.GA567@plap.qlogic.org> <1122558828.5132.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:9615 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262080AbVG1S7C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jul 2005 14:59:02 -0400
Content-Disposition: inline
In-Reply-To: <1122558828.5132.8.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, 28 Jul 2005, James Bottomley wrote:

> On Wed, 2005-07-27 at 22:10 -0700, Andrew Vasquez wrote:
> > Would you also apply the attached patch which adds the appropriate
> > FW_LOADER pre-requisite and a separate entry for ISP24xx support.
> 
> That's what I see reading the code; however, it looks like it's *only*
> the 24xx that needs it (qla24xx_load_risc_hotplug).  The patch below
> pulls in the FW loader for every qlogic fibre driver, not just the
> qla24xx; is there a reason for doing this?

Yes, I've been working on a set of patches which add this
functionality across the board with supported ISP types (21xx, 22xx,
23xx).  I should have some patches for submission in next week's
time-frame.  So rather than a adding #if code around the relevant 24xx
specific codes in qla2xxx, I chose the fw_loader path for all types.

-- 
Andrew Vasquez
