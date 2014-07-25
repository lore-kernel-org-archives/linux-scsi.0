From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Block/SCSI data integrity update v2
Date: Fri, 25 Jul 2014 16:34:15 -0400
Message-ID: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38258 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaGYUda (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2014 16:33:30 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6PKXS6O028048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:29 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXRLR019817
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:28 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXRY4003604
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:27 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is the data integrity patch series originally submitted for 3.16.
It has been rebased on top of the current 3.17 SCSI queue tree. I
believe I have addressed all the changes requested in the reviews. Aside
from a code cleanup in the sd prot_op code there are no functional
changes.

 - bi_special is now an anonymous union similar to how we do it in
   struct request [02/14]

 - Split integrity calculation cleanup into a separate patch [06/14]

 - The "disk" flag has been renamed "device_is_integrity_capable"
   [09/14]

 - Dropped bio integrity flag accessor functions [10/14]

 - Augmented patch description for the integrity checksum flag [11/14]

 - T10 library relocated to block/ [13/14]

 - A couple of tweaks in the sd patch to make things work on top of the
   current SCSI queue tree [14/14]

-- 
Martin K. Petersen	Oracle Linux Engineering

