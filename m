From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Bidirectional support
Date: Tue, 18 Nov 2003 17:50:15 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031118175015.A29355@infradead.org>
References: <OFADB546DA.E3228E33-ONC2256DE2.005FDDD5-C2256DE2.0061252A@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:21252 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263752AbTKRRuQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 12:50:16 -0500
Content-Disposition: inline
In-Reply-To: <OFADB546DA.E3228E33-ONC2256DE2.005FDDD5-C2256DE2.0061252A@il.ibm.com>; from LIRANS@il.ibm.com on Tue, Nov 18, 2003 at 07:41:05PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Liran Schour <LIRANS@il.ibm.com>
Cc: linux-scsi@vger.kernel.org, Muli Ben-Yehuda <MULI@il.ibm.com>

On Tue, Nov 18, 2003 at 07:41:05PM +0200, Liran Schour wrote:
> The OSD standard requires support for bidirectional commands (write and get
> obj attribute at the same command for example). The SAM-3 defines that in
> order to execute a SCSI command the caller should supply an input an output
> buffer. It seems that in the current Linux SCSI implementation the API
> accept only one buffer, input our output buffer depends on the
> data_direction flag.
> Is there some work going on trying to implement bidirectional support?

I haven't heard about such work beeing done.

> Is it sound reasonable to extend the scatter-gather structure to include
> data direction flag and by that bypass the interface problem and allow
> support for bidirectional commands?

Why do you need the flag in the scatterlist?  We already have a dma_direction
enum in the scsi_cmnd that's pased to the dma mapping routines, it may
be DMA_BIDRECTIONAL although that's currently not used by any code.

