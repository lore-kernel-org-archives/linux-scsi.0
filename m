From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Reviews, please
Date: Tue, 24 Nov 2015 07:37:39 -0500
Message-ID: <yq1oaejlgj0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34788 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbbKXMhm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2015 07:37:42 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tAOCbf4V028703
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2015 12:37:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tAOCbfJn028605
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2015 12:37:41 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tAOCbfta029211
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2015 12:37:41 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I spent last night cleaning up patchwork. Not entirely done yet but
getting down to a manageable size:

	https://patchwork.kernel.org/project/linux-scsi/list/


These are 4.4 fixes that I'd like to get some more reviews for:

	scsi_debug: fix prevent_allow+verify regressions
	https://patchwork.kernel.org/patch/7676711/

	Fix a bdi reregistration race, v2
	https://patchwork.kernel.org/patch/7671671/

	Revert "scsi: Fix a bdi reregistration race"
	https://patchwork.kernel.org/patch/7671661/

	[2/2] Fix a memory leak in scsi_host_dev_release()
	https://patchwork.kernel.org/patch/7671391/

	[1/2] scsi_transport_fc: Introduce scsi_host_{get,put}()
	https://patchwork.kernel.org/patch/7671381/

	[3/3] MAINTAINERS: Add myself as co-maintainer of the SCSI subsystem.
	https://patchwork.kernel.org/patch/7614881/

	[2/3] block/sd: Fix device-imposed transfer length limits
	https://patchwork.kernel.org/patch/7614871/

	[1/3] sd: Make discard granularity match logical block size when LBPRZ=1
	https://patchwork.kernel.org/patch/7614861/


And for 4.5 the following ones are low-hanging fruit.

	scsi: hisi_sas: remove dependency on of_irq_count
	https://patchwork.kernel.org/patch/7656691/

	scsi: use sector_div instead of do_div
	https://patchwork.kernel.org/patch/7669841/

	mvsas: add SGPIO support to Marvell 94xx
	https://patchwork.kernel.org/patch/7610411/

	aacraid: aac_release_resources() can be static
	https://patchwork.kernel.org/patch/7588331/

I staged the reviewed portion of Finn's ncr5380 series last week but it
looks like there is some issues to be worked out. So I'll let that
simmer in a different branch for now.

I will take a look at the ALUA series today. And then there's the
mountain of UFS related patch series...

-- 
Martin K. Petersen	Oracle Linux Engineering
