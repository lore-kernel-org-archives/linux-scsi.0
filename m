From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Reviews, please
Date: Thu, 17 Dec 2015 22:32:01 -0500
Message-ID: <yq1bn9osa8e.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30526 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbbLRDcG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2015 22:32:06 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tBI3W4mX001623
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 03:32:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tBI3W4m5022909
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 03:32:04 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tBI3W3wj010719
	for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 03:32:03 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


There are not a whole lot of working days left before the 4.5 merge
window opens...


Driver updates needing full reviews:

	https://patchwork.kernel.org/bundle/mkp/be2iscsi/
	https://patchwork.kernel.org/bundle/mkp/qla2xxx/


lpfc looks to be in decent shape but another set of eyes wouldn't hurt:

	https://patchwork.kernel.org/bundle/mkp/lpfc/


Doug Gilbert, maybe you could take a look at this series since it mainly
touches your code?

	https://patchwork.kernel.org/bundle/mkp/constants/


hpsa 2/3 and 3/3 needs a non-PMCS review:

	https://patchwork.kernel.org/bundle/mkp/hpsa/


cxlflash needs a non-IBM review:

	https://patchwork.kernel.org/bundle/mkp/cxlflash/


storvsc patch 2/4 is missing a review. Johannes, you reviewed the rest
of this series. Care to take a look?

	https://patchwork.kernel.org/bundle/mkp/storvsc/


This mvsas GPIO patch hasn't gotten any attention. Would be sad to drop
a sizable patch adding new functionality:

	https://patchwork.kernel.org/patch/7610411/


Ewan's /proc/scsi/scsi iterator fixes need comments:

	https://patchwork.kernel.org/bundle/mkp/bus_device/


Hannes' ALUA follow-up series is only partially reviewed. I'll review
the patches I haven't done already. But I would like another set of eyes
on these:

	https://patchwork.kernel.org/bundle/mkp/alua/


I dropped everything that's been sitting for more than a month. There
are still a bunch of trivial fixes on the list that would be nice to get
either acked or nacked:

	https://patchwork.kernel.org/project/linux-scsi/list/

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
