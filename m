From: Saeed Bishara <Saeed.Bishara@il.marvell.com>
Subject: IO buffer alignment for block devices
Date: Mon, 13 Sep 2004 15:48:41 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41459729.5060106@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shosh.galileo.co.il ([199.203.130.250]:18353 "EHLO
	il.marvell.com") by vger.kernel.org with ESMTP id S266646AbUIMMst
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 08:48:49 -0400
Received: from [127.0.0.1] ([10.4.22.164])
	by il.marvell.com (8.12.10/8.12.10) with ESMTP id i8DClkbw011732
	for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2004 15:47:47 +0300 (IDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
    Is there any minimal alignment for the IO buffers (sg and single) 
sent to a scsi LLD?
    I found that buffers that come from buffer cache, page cache and sg 
are page aligned , and the raw driver send sector aligned     buffers.
    so can I assume that the minimal alignment of the buffer is 512 bytes?
thanks
saeed

