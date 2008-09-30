From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Disable advansys on ARM and MIPS
Date: Tue, 30 Sep 2008 03:34:39 -0400
Message-ID: <20080930073439.GA11059@infradead.org>
References: <20080930072354.GA24133@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41645 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYI3Hek (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 03:34:40 -0400
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

I'd still call it broken everywhere.  People who really care about this
driver should just help with the full dma api translation, if only by
testing patches.

