From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: pass through support: question: blk_rq_map_sg() usage...
Date: Thu, 9 Oct 2008 11:08:37 -0700
Message-ID: <F86BE6EA-AE56-4780-96A4-01C67625C0D5@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:21546 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbYJISIj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Oct 2008 14:08:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Smart <James.Smart@Emulex.Com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

Hi,

I've got a quick question on the blk_rq_map_sg() API usage.
In an efforts of implementing pass through support on FC transport  
layer, the transport would call blk_rq_map_sg() API to map the pages  
in the bio structure so that the LLD could DMA to/from the mapped  
addresses - as specified in the section 2.2 of the ~/Documentation/ 
block/biodoc.txt.
To me, it seems like a right way to do..., could anyone comment on  
this approach?
Also, I couldn't find symmetric counter-part for the API (i.e.,  
blk_rq_unmap_sg() or similar).
Does this means that we don't need to unmap those addresses?

Thank you,
Seokmann

