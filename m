From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: 2.6.34-rc3 : Badness at lib/dma-debug.c:820 during ibmvscsi
 init
Date: Tue, 27 Apr 2010 18:34:51 +0900
Message-ID: <20100427183609W.fujita.tomonori@lab.ntt.co.jp>
References: <4BB590C6.3090108@in.ibm.com>
	<20100402154959K.fujita.tomonori@lab.ntt.co.jp>
	<1272351921.24542.8.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36747 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0D0JfH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 05:35:07 -0400
In-Reply-To: <1272351921.24542.8.camel@pasglop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: benh@kernel.crashing.org
Cc: fujita.tomonori@lab.ntt.co.jp, sachinp@in.ibm.com, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org

On Tue, 27 Apr 2010 17:05:21 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Fri, 2010-04-02 at 15:50 +0900, FUJITA Tomonori wrote:
> 
> > Thanks, here's the patch in the proper format.
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] ibmvscsi: fix DMA API misuse
> > 
> > ibmvscsi uses dma_unmap_single() for buffers mapped via
> > dma_map_sg(). It works however it's the API violation. The DMA debug
> > facility complains about it:
> 
> Hi folks !
> 
> Is this going to be merged via the scsi tree ?

Already merged (a71fa1fc43a29133f13ae6ada1a389ca298c0934).
