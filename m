From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Subject: diskdump fails on x3850 (x86_64)
Date: Tue, 05 Feb 2008 18:19:57 +0530
Message-ID: <47A85B75.5010401@linux.vnet.ibm.com>
Reply-To: ciju@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:47194 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752476AbYBEMxy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 07:53:54 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m15CrqrW012215
	for <linux-scsi@vger.kernel.org>; Tue, 5 Feb 2008 18:23:52 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m15CrpF5962656
	for <linux-scsi@vger.kernel.org>; Tue, 5 Feb 2008 18:23:52 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m15CrpwS023366
	for <linux-scsi@vger.kernel.org>; Tue, 5 Feb 2008 12:53:51 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: david_chaw@adaptec.com, chandru@in.ibm.com

Hello folks,

Diskdump on x3850 with adp94xx driver is not working (Redhat Enterprise Linux 4.6). 
'Service diskdump restart' fails. Is there any plan to support it?

Thanks
Ciju
