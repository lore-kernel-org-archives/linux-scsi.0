From: Liran Schour <LIRANS@il.ibm.com>
Subject: Re: Bidirectional support
Date: Tue, 18 Nov 2003 22:02:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF4C1DEC00.6F7133BA-ONC2256DE2.006DB245-C2256DE2.006E0E82@il.ibm.com>
References: <20031118175015.A29355@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:30165 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S263770AbTKRUEo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 15:04:44 -0500
In-Reply-To: <20031118175015.A29355@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, Muli Ben-Yehuda <MULI@il.ibm.com>






Christoph Hellwig wrote:
>
> > Is it sound reasonable to extend the scatter-gather structure to
include
> > data direction flag and by that bypass the interface problem and allow
> > support for bidirectional commands?
>
> Why do you need the flag in the scatterlist?  We already have a
dma_direction
> enum in the scsi_cmnd that's pased to the dma mapping routines, it may
> be DMA_BIDRECTIONAL although that's currently not used by any code.

I can use this DMA_BIDIRECTIONAL flag. But I still do need somthing like a
scatterlist to overcome the fact that we have only one pointer for data
buffer instead of two, one for data out and one for data in.

- Liran

