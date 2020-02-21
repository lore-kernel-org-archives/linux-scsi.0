Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8896CC35669
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 23:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C7C92072C
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 23:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="umgXYyMC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgBUXdP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 18:33:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58320 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBUXdO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2020 18:33:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LNXA0U075139;
        Fri, 21 Feb 2020 23:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=9j5b7b+w0nwphCkI5TfZ3o31U9O+Mm3MbmyV6d0EaAU=;
 b=umgXYyMCJ+ncphOthzvUT/kQUfnah5glVJ5R3kvXFKKXa0HPjmP0VctA4mE7KGuJDdIx
 xxVBmfJwJM6K8G6M+LdNkw1+f+lfl/6qde7FsOuO31kDxMDVshj5ZTplm5HrliRbnfF4
 YFcI8J3XIkObc9MzhCpPUqR3wwgVn12bX8gdq84L7ig50Yehbc/kYzDjBbZtM5eHmPrX
 oSF9YCPdI5OSwzszZXyHXMWNK51ddqAt9P0l8C/V7u66rW7uBQLAJQRR6krqjA/lWV4c
 J3nHwCFy88mfLj6czS6mEKuUMRHh9urr8A7n/F8FzTx5/AwDbVIpV3RXABl+EgPU0VgY dQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2y8uddke8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 23:33:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LNVnOD175585;
        Fri, 21 Feb 2020 23:33:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2y8ud7th27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 23:33:09 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01LNX6jm004499;
        Fri, 21 Feb 2020 23:33:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 15:33:06 -0800
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/25] qla2xxx: Updates for the driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200212214436.25532-1-hmadhani@marvell.com>
Date:   Fri, 21 Feb 2020 18:33:04 -0500
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com> (Himanshu Madhani's
        message of "Wed, 12 Feb 2020 13:44:11 -0800")
Message-ID: <yq1r1ynqzwv.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210176
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Himanshu,

> This series addes enhancements to the driver in the area of FDMI
> commands and adding support for RDP command. This series also adds
> support for Beacon LED/D-Port SysFS nodes.
>
> There are few other patches which are cleanup to improve readability
> as well as consolidates code.  
>
> Please apply this series to 5.7.0/scsi-misc at your earliest
> convenience.

Applied to 5.7/scsi-queue. This series lit up like a Xmas tree in
checkpatch. Next time, please verify before posting.

-- 
Martin K. Petersen	Oracle Linux Engineering
