From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: mptNsas MSI-X fixes
Date: Fri,  3 Jan 2014 19:16:54 -0500
Message-ID: <1388794616-23560-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42538 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaADARP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 19:17:15 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id s040HE31021722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 4 Jan 2014 00:17:15 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s040HEg8016489
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 4 Jan 2014 00:17:14 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s040HEHC016481
	for <linux-scsi@vger.kernel.org>; Sat, 4 Jan 2014 00:17:14 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We found a couple of MSI-X related problems with mptNsas on very large
systems. The patches below contain fixes for mpt2sas and mpt3sas
respectively.

 drivers/scsi/mpt2sas/mpt2sas_base.c | 64 ++++++++++++++++++++----------------------------------
 drivers/scsi/mpt3sas/mpt3sas_base.c | 73 ++++++++++++++++++--------------------------------------------
 2 files changed, 44 insertions(+), 93 deletions(-)

-- 
Martin K. Petersen	Oracle Linux Engineering

