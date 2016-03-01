From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Reviews, please
Date: Mon, 29 Feb 2016 21:37:29 -0500
Message-ID: <yq1bn6ydity.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31088 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbcCAChj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Feb 2016 21:37:39 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u212bbZR028848
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2016 02:37:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u212bbP5002181
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2016 02:37:37 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id u212bV4n019001
	for <linux-scsi@vger.kernel.org>; Tue, 1 Mar 2016 02:37:37 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Loose ends for 4.6:

aicasm: fix kbuild for separated build directories
	https://patchwork.kernel.org/patch/8298331/
	https://patchwork.kernel.org/patch/8343891/

qlogicpti: Return correct error code
	https://patchwork.kernel.org/patch/8338931/

scsi_transport_fc: Implement 'async_user_scan' module parameter
	https://patchwork.kernel.org/patch/8372621/

scsi_transport_fc: implement 'disable_target_scan' module parameter
	https://patchwork.kernel.org/patch/8372631/

snic: correctly check for array overrun on overly long version number
	https://patchwork.kernel.org/patch/8427331/

ufs:
	https://patchwork.kernel.org/bundle/mkp/ufs/

-- 
Martin K. Petersen	Oracle Linux Engineering
