From: Andi Kleen <ak@suse.de>
Subject: Re: Fusion problems with 2.6.5rc1 on AMD x86-64 III
Date: Wed, 17 Mar 2004 10:00:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040317100040.28304c12.ak@suse.de>
References: <20040317024917.630dcb86.ak@suse.de>
	<20040317060332.36d492ab.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:63187 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261241AbUCQJVs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 04:21:48 -0500
In-Reply-To: <20040317060332.36d492ab.ak@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org, emoore@lsil.com, James.Bottomley@HansenPartnership.com

On Wed, 17 Mar 2004 06:03:32 +0100
Andi Kleen <ak@suse.de> wrote:


> The actual problem is the recent consistent_dma_mask change from James. For some reason
> the x86-64 pci_alloc_consistent always sees an 0xffffffffffffffff dma mask now
> and that breaks Fusion.

I found some bugs in x86-64 code now that explained the problem. For some reason
the consistent mask patchkit seems to have triggered them. It's fixed now.

-Andi
