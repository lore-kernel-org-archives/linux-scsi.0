Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A937CA9EC0
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 02:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B0DD21835
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 02:03:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SH7nEEeS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbfJ2CDE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 22:03:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbfJ2CDE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 22:03:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T1xW2A118911;
        Tue, 29 Oct 2019 02:02:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=WLXrIzsT+ORz3zY9sJFwipI3wqa8DWsLZnI6XcJEvwM=;
 b=SH7nEEeSunLVapph2gXrh9osnfygzboBXBYhsILuQnPYAEGHKi1ku4LtupRh+lK+g1c9
 iYBLfJlr+fhBQ+2CI4aj9jJ9z/Zfz6S7fr2WsGCZ7ZD1v+gLoj7+5WITbvnloSx2KdsN
 uhguxc5dNcu5veXnFVHha4KRShF+A6pKdIbWKR3cCsUh8J9HodQOGRRKLJvjMoWxD1vc
 MCwb14NhYfAkLVdxF5O41LK8fm0p2CGr/x9w1g4Go6uCcgQpUGTM7Fp/QtkYMnDu5e7w
 aBGiEhAfBnyPt5TqMV0/4+if+Z6L9TVWFVjDbpfjbkQN5Sn7FBDJuHH0YI3rtM2xz/hm HQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vvdju5t8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 02:02:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T22jw2058075;
        Tue, 29 Oct 2019 02:02:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vvykt092y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 02:02:54 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9T22qZF028982;
        Tue, 29 Oct 2019 02:02:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 19:02:52 -0700
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <james.smart@broadcom.com>, <dick.kennedy@broadcom.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: lpfc: Make lpfc_debugfs_ras_log_data static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191028132556.16272-1-yuehaibing@huawei.com>
Date:   Mon, 28 Oct 2019 22:02:50 -0400
In-Reply-To: <20191028132556.16272-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Mon, 28 Oct 2019 21:25:56 +0800")
Message-ID: <yq1d0eg8g1h.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=971
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


YueHaibing,

> Fix sparse warning:
>
> drivers/scsi/lpfc/lpfc_debugfs.c:2083:1: warning:
>  symbol 'lpfc_debugfs_ras_log_data' was not declared. Should it be static?

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
