From: Brian King <brking@us.ibm.com>
Subject: [RFC] IBM Power RAID driver (ipr)
Date: Fri, 16 Jan 2004 15:59:54 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40085EDA.4010802@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:34464 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265821AbUAPV75 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 16:59:57 -0500
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e1.ny.us.ibm.com (8.12.10/NS PXFA) with ESMTP id i0GLxuuh469172
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2004 16:59:56 -0500
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i0GLxttg104634
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2004 16:59:56 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have just written a LLD for the IBM Power RAID family of adapters.
This includes several IBM iSeries and pSeries SCSI adapters. Please
review for 2.6 inclusion.

The driver can be found at:

http://www-124.ibm.com/storageio/ipr/patch-2.6.1-ipr-2.0.0-1.gz


Thanks

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

