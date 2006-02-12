From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] ipr: don't doublefree pages from scatterlist
Date: Sun, 12 Feb 2006 22:29:32 +0100
Message-ID: <200602122229.33244.ak@suse.de>
References: <Pine.LNX.4.61.0602040004020.5406@goblin.wat.veritas.com> <20060211223810.GA12064@tau.solarneutrino.net> <Pine.LNX.4.61.0602121838050.15101@goblin.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:7367 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751460AbWBLVrB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 16:47:01 -0500
In-Reply-To: <Pine.LNX.4.61.0602121838050.15101@goblin.wat.veritas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Ryan Richter <ryan@tau.solarneutrino.net>, Brian King <brking@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, James.Bottomley@steeleye.com, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sunday 12 February 2006 19:57, Hugh Dickins wrote:

> So I'd like to believe that your x86_64-gart-dma-merge.patch is the
> final answer to this issue, and see it go forward into 2.6.16-rc -
> if you feel it's ready now.  Then we can just throw away those driver
> patches I posted a week ago (including the "ipr" one of this thread).

Yes, it's probably ready to go. I will submit it later if Andrew doesn't
beat me.

-Andi
