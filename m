From: Sachin Sant <sachinp@in.ibm.com>
Subject: SCSI reserve / release support for SG
Date: Fri, 14 Nov 2003 16:59:22 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FB4BC92.D43703BE@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:40871 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262456AbTKNL0g
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 06:26:36 -0500
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e35.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id hAEBQWcF299224
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2003 06:26:32 -0500
Received: from in.ibm.com (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay04.boulder.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id hAEBQSxN122658
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2003 04:26:31 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Does Current sg driver offer SCSI reserve/release command in its 
open/close function. I am trying to run on a SAN or Cluster environment
which requires support for this reserve/release command. 

If not then are there any plans to support reserve/release SCSI command
so that sg driver can provide these options for its users in its
open/close function  It will make all I/O operation with sg driver more
reliable especially in data storage area. 

-- 
Thanks
-Sachin
-----------------------------------
Sachin Sant
Linux Technology Center
IBM Software Lab
Bangalore, INDIA.

sachinp@in.ibm.com
Ph: 91-80-5044647
-----------------------------------
