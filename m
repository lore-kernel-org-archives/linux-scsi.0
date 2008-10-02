From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [PATCH] scsi: Disable advansys on ARM and MIPS
Date: Thu, 2 Oct 2008 09:49:15 +0200
Message-ID: <20081002074915.GA13602@deprecation.cyrius.com>
References: <20080930072354.GA24133@deprecation.cyrius.com> <20080930161259.GA13822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:2580 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbYJBHt2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2008 03:49:28 -0400
Content-Disposition: inline
In-Reply-To: <20080930161259.GA13822@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx> [2008-09-30 10:13]:
> > Commit 9d511a4b29de6764931343d03e493f2e04df0271 ("advansys: Changes to
> > work on parisc") removed the "depends on BROKEN || X86_32" line from
> > advansys' Kconfig entry.  Unfortunately, this led to compilation errors
> > on ARM and MIPS (that are not related).  Since nobody looked into this
> > issue since I reported it in January 2008 and Russell King said that
> > the driver is completely broken on ARM, let's undo some of the damage
> > caused by the removal of the "BROKEN" Kconfig depends by disabling the
> > driver on ARM and MIPS.
> 
> Huh?  I've looked into it.  ARM and MIPS provide half of an API but not
> the other half.  These architectures are broken.

Maybe, but the point is that advansys was marked as BROKEN on !X86_32
before and now it's not, so the ARM/MIPS compilation errors show up
and that's a regression.  What you say is a good argument for my patch
to disable advansys for ARM/MIPS in Kconfig.

-- 
Martin Michlmayr
http://www.cyrius.com/
