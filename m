From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Scatter-gather segment merges by IOMMU?
Date: Fri, 08 Aug 2008 21:44:31 +0200
Message-ID: <489CA21F.1030604@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50239 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYHHToe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 15:44:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Hi all,

the block layer usually tries to merge s/g segments if consecutive 
segments combined fit into the queue's max_segment_size.  When such a 
scatter gather list is DMA-mapped, can it happen that an IOMMU collapses 
the elements even further, so that sg_dma_len() of a DMA-mapped s/g 
segment exceeds max_segment_size?

As I understood some discussions in the past, this could indeed happen, 
which is a nuisance.  But I may have misunderstood something, or 
something may have changed in the meantime...
-- 
Stefan Richter
-=====-==--- =--- -=---
http://arcgraph.de/sr/
