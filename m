From: chinmay albal <albal@in.ibm.com>
Subject: need inputs on scsi_dump_status feature in kernel 2.4.x
Date: Thu, 06 Nov 2003 16:06:59 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FAA244B.4080507@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:33939 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263488AbTKFKd7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 05:33:59 -0500
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e35.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id hA6AXwcF456134
	for <linux-scsi@vger.kernel.org>; Thu, 6 Nov 2003 05:33:58 -0500
Received: from in.ibm.com (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay04.boulder.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id hA6AXs6s128978
	for <linux-scsi@vger.kernel.org>; Thu, 6 Nov 2003 03:33:57 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

While using the echo "scsi dump #" > /proc/scsi/scsi feature, the system 
traps while trying to print out the dump of pending block device 
requests in function scsi_dump_status of scsi.c. The cause for this 
could be that the structure queue_head is not being populated.
A few attempts that I tried to populate this structure have failed. Can 
anyone please let me know under what circumstances does this structure 
get filled up or is there any consistent way to generate a list of 
pending block requests.

Iam aware that this feature is no longer being used in the 2.6 kernels, 
but was curious to know why this scenario happens on the 2.4 kernels.
Regards
- Chinmay

