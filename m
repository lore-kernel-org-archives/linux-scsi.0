From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 01/19] scsi: add __init/__exit macros to ibmvstgt.c
Date: Tue, 22 Dec 2009 10:56:24 -0800
Message-ID: <20091222105624.88378ebe.akpm@linux-foundation.org>
References: <200912220027.nBM0Rcrj005361@imap1.linux-foundation.org>
	<200912220806.32904.PeterHuewe@gmx.de>
	<1261500404.2774.15.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980AbZLVS5r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2009 13:57:47 -0500
In-Reply-To: <1261500404.2774.15.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Peter Huewe <PeterHuewe@gmx.de>, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au, trivial@kernel.org

On Tue, 22 Dec 2009 10:46:44 -0600 James Bottomley <James.Bottomley@suse.de> wrote:

> > 
> > this patch is floating around for almost half a year (2009/06/23) and I was 
> > wondering if there is anything wrong with it, or why it doesn't get merged 
> > upstream.
> 
> well, it still has to be tested.  I'd guess IBM is putting out other
> fires, since it's really just cosmetic, even in terms of memory savings.

James, this is pathetic.  Why not just read the darned code for eighteen
seconds?  You can see that the patch is correct and safe - you don't
have to wait for some rigor-mortis-maintainer to read it for you.


