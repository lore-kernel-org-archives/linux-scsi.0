From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: Disable advansys on ARM and MIPS
Date: Tue, 30 Sep 2008 10:13:00 -0600
Message-ID: <20080930161259.GA13822@parisc-linux.org>
References: <20080930072354.GA24133@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42813 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYI3QNR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 12:13:17 -0400
Content-Disposition: inline
In-Reply-To: <20080930072354.GA24133@deprecation.cyrius.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 30, 2008 at 10:23:54AM +0300, Martin Michlmayr wrote:
> Commit 9d511a4b29de6764931343d03e493f2e04df0271 ("advansys: Changes to
> work on parisc") removed the "depends on BROKEN || X86_32" line from
> advansys' Kconfig entry.  Unfortunately, this led to compilation errors
> on ARM and MIPS (that are not related).  Since nobody looked into this
> issue since I reported it in January 2008 and Russell King said that
> the driver is completely broken on ARM, let's undo some of the damage
> caused by the removal of the "BROKEN" Kconfig depends by disabling the
> driver on ARM and MIPS.

Huh?  I've looked into it.  ARM and MIPS provide half of an API but not
the other half.  These architectures are broken.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
