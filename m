From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 17:22:17 -0500
Message-ID: <4D87CF99.7040008@linux.vnet.ibm.com>
References: <20110307134033K.fujita.tomonori@lab.ntt.co.jp> <1299508803.12730.1.camel@mulgrave.site> <4D83C78D.5040908@linux.vnet.ibm.com> <20110321100909E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50903 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab1CUWWW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 18:22:22 -0400
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2LLw2OR023202
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 17:58:02 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 127246E8036
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 18:22:19 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2LMMIJr2506894
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 18:22:18 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2LMMHAs000825
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 19:22:18 -0300
In-Reply-To: <20110321100909E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

Tomo,

Thanks for all the work you've done with this driver. It is much appreciated.

What sort of performance are you seeing with this? With filebacked devices, I
was seeing around 1 MB/sec doing a basic disktest run. I haven't compared this
to ibmvstgt, but I'm pretty sure we did a fair bit better there. Perhaps I've got
some setup issue?

I tried a ramdisk device and saw this on the server:


DMA_TO_DEVICE not supported for RAMDISK_DR with task_sg_chaining=1



All my I/O on the client timed out because of this. 

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


