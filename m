From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: Question: how to map SCSI data DMA address to virtual address?
Date: Thu, 2 Mar 2006 10:21:51 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C2651420C3@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:2046 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1752021AbWCBRVz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 12:21:55 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

Thursday, March 02, 2006 12:09 PM Christoph Hellwig wrote:
> For each sg list entry do something like:
> 
> 	buffer = kmap_atomic(sg->page, KM_USER0) + sg->offset;
> 	<access buffer>
> 	kunmap_atomic(buffer - sg->offset, KM_USER0);
Thank you for your comment!
I'll try with this.

Thank you again.
