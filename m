From: Brian King <brking@us.ibm.com>
Subject: Handling ordered tags
Date: Mon, 28 Mar 2005 15:45:13 -0600
Message-ID: <42487AE9.4000904@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49614 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262087AbVC1VpP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 16:45:15 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j2SLjEPO017347
	for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2005 16:45:14 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j2SLjEW5234718
	for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2005 16:45:14 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j2SLjE2s001886
	for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2005 16:45:14 -0500
Received: from [9.10.86.27] (kaled.rchland.ibm.com [9.10.86.27])
	by d01av01.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j2SLjDwB001825
	for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2005 16:45:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm trying to understand all the implications of allowing ordered tags
for a SCSI LLD, especially when running QERR=0 with autosense and no ACA.

Are any of these problems a concern given how ordered tags are used in Linux?

1. If an ordered tag is sent and a previously sent simple tagged op completes
   with a failure, the ordered tag will still execute.
2. If an ordered tag is sent and completes with a failure, any simple tags sent
   after it will execute.

I guess my bigger question is, are there any additional requirements on an LLD
in order for it to support ordered tags? Can the LLD send back responses in any
order?

Thanks


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
