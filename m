From: Andi Kleen <ak@muc.de>
Subject: Re: Fw: [Bugme-new] [Bug 6052] New: Megaraid file corruption and performance degradation on x86_64 with 8G RAM
Date: 11 Feb 2006 10:37:52 +0100
Message-ID: <20060211093752.GB50528@muc.de>
References: <20060210112640.4637dfdb.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin.muc.de ([193.149.48.1]:30736 "EHLO mail.muc.de")
	by vger.kernel.org with ESMTP id S1750788AbWBKJh7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Feb 2006 04:37:59 -0500
Date: Sat, 11 Feb 2006 10:37:52 +0100
Content-Disposition: inline
In-Reply-To: <20060210112640.4637dfdb.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Neela.Kolli@engenio.com, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, bloch@verdurin.com

On Fri, Feb 10, 2006 at 11:26:40AM -0800, Andrew Morton wrote:
> 
> 
> Begin forwarded message:

Hmm, could be the merging issue too? Does megaraid do anything
funny with sg lists? Does iommu=nomerge help?

If yes apply

ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/gart-dma-merge

and report back.

-Andi
