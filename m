From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Last call for 4.5
Date: Thu, 07 Jan 2016 22:30:12 -0500
Message-ID: <yq1egdshhob.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38822 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbcAHDaQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2016 22:30:16 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u083UFrj029350
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 8 Jan 2016 03:30:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u083UFWf011932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 8 Jan 2016 03:30:15 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id u083UEFA028845
	for <linux-scsi@vger.kernel.org>; Fri, 8 Jan 2016 03:30:14 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hannes is on vacation this week and I would like to get the remaining
pieces reviewed before the merge window opens.

3w-xxxx:
	https://patchwork.kernel.org/patch/7920471/

	One-liner.

aacraid:
	https://patchwork.kernel.org/bundle/mkp/aacraid/

	Need reviews for revised patches: 1, 5, 7, 8.

be2iscsi:
	https://patchwork.kernel.org/bundle/mkp/be2iscsi/

	Need reviews for revised patches: 2, 3, 4, 10, 13, 14, 15.

        Tomas, Johannes: I believe you guys asked for some of these
        changes...

imm:
	https://patchwork.kernel.org/patch/7954581/

hisi_sas:
	https://patchwork.kernel.org/bundle/mkp/hisi_sas/

	Small fixes. Should be quick and easy.

megaraid_sas:
	https://patchwork.kernel.org/bundle/mkp/megaraid_sas/

	I will review this series tomorrow. Another set of eyes would be
	great.

-- 
Martin K. Petersen	Oracle Linux Engineering
