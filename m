From: "Nayak, Samdeep" <Samdeep_Nayak@adaptec.com>
Subject: Raw IO with High mem support.
Date: Tue, 11 Nov 2003 23:32:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B38A3B4F283DBA419282705B57A2425B154AC1@aime2k02.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from list.adaptec.com ([216.52.22.18]:26276 "EHLO list.adaptec.com")
	by vger.kernel.org with ESMTP id S261863AbTKLHcG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2003 02:32:06 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by list.adaptec.com (8.12.8/8.12.8) with ESMTP id hAC7VQaX023124
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2003 23:31:26 -0800
Received: from aime2k02.adaptec.com (aime2k02.adaptec.com [10.25.8.42])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id hAC7W2J21332
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2003 23:32:02 -0800
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am running into a strange performance issue after I upgraded my system
ram to 2Gig. Earlier my system had 896MB and I was getting decent
performance with character raw IO. However after rebuilding the kernel
to support 4Gig Memory with 3Gig virtual memory on 2.4.X kernel, the
performance seems to drop drastically. Physically removing the RAM got
me back to the original performance.  I am still trying to analyze this
and any pointers to High Memory support with raw device would be greatly
appreciated.

Thanks in advance,
-Samdeep


