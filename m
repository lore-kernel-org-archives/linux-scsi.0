From: Brian King <brking@us.ibm.com>
Subject: [PATCH] Make retries obey host_self_blocked flag
Date: Thu, 05 Feb 2004 14:45:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4022AB54.1020209@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:10160 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S266684AbUBEUpN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2004 15:45:13 -0500
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e35.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id i15KjCwX466740
	for <linux-scsi@vger.kernel.org>; Thu, 5 Feb 2004 15:45:12 -0500
Received: from us.ibm.com (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i15Kj9TW064712
	for <linux-scsi@vger.kernel.org>; Thu, 5 Feb 2004 13:45:09 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patch against 2.6.2 will prevent the midlayer from
issuing retries if host_self_blocked is set. This was raised as an
issue here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=107357742430401&w=2

I'm trying to improve and extend scsi_block_requests, and this is
the first, and hopefully least controversial, step.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

