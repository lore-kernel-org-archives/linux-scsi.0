From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: Disable advansys on ARM and MIPS
Date: Thu, 2 Oct 2008 05:24:13 -0600
Message-ID: <20081002112413.GL13822@parisc-linux.org>
References: <20080930072354.GA24133@deprecation.cyrius.com> <20080930161259.GA13822@parisc-linux.org> <20081002074915.GA13602@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56005 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYJBLY3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 07:24:29 -0400
Content-Disposition: inline
In-Reply-To: <20081002074915.GA13602@deprecation.cyrius.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 02, 2008 at 09:49:15AM +0200, Martin Michlmayr wrote:
> * Matthew Wilcox <matthew@wil.cx> [2008-09-30 10:13]:
> > Huh?  I've looked into it.  ARM and MIPS provide half of an API but not
> > the other half.  These architectures are broken.
> 
> Maybe, but the point is that advansys was marked as BROKEN on !X86_32
> before and now it's not, so the ARM/MIPS compilation errors show up
> and that's a regression.  What you say is a good argument for my patch
> to disable advansys for ARM/MIPS in Kconfig.

No, ARM and MIPS need to just add stub functions that do nothing.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
