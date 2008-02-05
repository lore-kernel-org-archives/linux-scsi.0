From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 01/13] git-scsi-misc: fix isa/pcmcia compile problem
Date: Tue, 05 Feb 2008 08:41:15 -0600
Message-ID: <1202222475.3133.0.camel@localhost.localdomain>
References: <200802050752.m157qqYH010688@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56796 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726AbYBEOlU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 09:41:20 -0500
In-Reply-To: <200802050752.m157qqYH010688@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, htejun@gmail.com, kamalesh@linux.vnet.ibm.com

On Mon, 2008-02-04 at 23:53 -0800, akpm@linux-foundation.org wrote:
> From: Tejun Heo <htejun@gmail.com>
> 
> aha152x.c and fdomain are built twice - once for the isa driver and once
> for the PCMCIA one.  Through #ifdefs, the compiled codes are slightly
> different; thus, global symbols need to be given different names depending
> on which flavor is being built.  This patch adds GLOBAL() macro to
> aha152x.h and fdomain.h which change the symbol depending on PCMCIA.
> 
> This bug has always existed but has been masked by the fact the
> drivers/scsi/pcmcia used subdir-(y|m) instead of obj-(y|m) which made
> drivers/scsi/pcmcia/built_in.o not linked into the kernel and thus avoided
> the duplicate symbols during compilation.
> 
> [akpm@linux-foundation.org: coding-style fixes]
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

An alternative fix for this is already in.

Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Fri Jan 18 17:47:56 2008 -0600

    [SCSI] fix pcmcia compile problem


James


