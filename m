From: ian <spyro@f2s.com>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Thu, 01 Nov 2007 15:33:15 +0000
Message-ID: <1193931195.25899.280.camel@wirenth>
References: <1193864605.25899.253.camel@wirenth>
	 <20071031213447.GF15111@parisc-linux.org>
	 <1193910526.25899.278.camel@wirenth>  <20071101100717.GA26906@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outmail1.freedom2surf.net ([194.106.33.237]:45810 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbXKAPgQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2007 11:36:16 -0400
In-Reply-To: <20071101100717.GA26906@linux-sh.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mundt <lethal@linux-sh.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org

On Thu, 2007-11-01 at 19:07 +0900, Paul Mundt wrote:
> Indeed. The SH case for OHCI on MFDs is the same. So that's at least 2
> users. 

three if you count James SCSI card.

