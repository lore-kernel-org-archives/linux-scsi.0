Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D287CA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 23:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFE53222BD
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 23:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nOvWna+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfJRXfi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 19:35:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56848 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbfJRXfi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 19:35:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9INYEIp170246;
        Fri, 18 Oct 2019 23:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=huvT8ZM2Xy/B3STmx8zpVObLoqN1ersNBDz5Kt5OaNk=;
 b=nOvWna+htThCGarMcryjeZjdJbD1VuRKEMHqQb800Lx/thch9KZuvmR96RvKnd6wrQoO
 UcGmPumieiRYySnE+mfxTzQqTFTAHxa04MXr6/9iyJn7DJ1j7kCgmXHOflPulTTu2BPR
 UYoImKhMWWcHkv1OnJ9srNTSj6EDjkAsycxE7wx02nPG8jOne+sf6YKOUu+6+P6YPI8t
 ghb/BGI4hyzWmHnbMTdYgy2DiNqKd3p2ZlMQhIbpOzQy1rwH8zWHiMphq8nAMKaonfvg
 x1yc61cDhc7M+V48q0/ZmTpLGlGCpb6Ks7RBdATEGyWgrAZzak01G7D6a7zrBJl9wIuL kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vq0q4ej6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 23:35:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9INTjUG068963;
        Fri, 18 Oct 2019 23:35:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vq0dytg06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 23:35:33 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9INZWAE002590;
        Fri, 18 Oct 2019 23:35:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 23:35:31 +0000
To:     <balsundar.p@microsemi.com>
Cc:     <linux-scsi@vger.kernel.org>, <jejb@linux.vnet.ibm.com>,
        <aacraid@microsemi.com>
Subject: Re: [PATCH 0/7] scsi: aacraid updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1571120524-6037-1-git-send-email-balsundar.p@microsemi.com>
Date:   Fri, 18 Oct 2019 19:35:30 -0400
In-Reply-To: <1571120524-6037-1-git-send-email-balsundar.p@microsemi.com>
        (balsundar p.'s message of "Tue, 15 Oct 2019 11:51:57 +0530")
Message-ID: <yq18sphhbjx.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180211
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Balsundar,

> Balsundar P (7):
>   scsi: aacraid: Fix illegal data read or write beyond last LBA
>   scsi: aacraid: Fixed failure to check IO response and report IO error
>   scsi: aacraid: Fixed basecode assert when IOP reset is sent by driver
>   scsi: aacraid: setting different timeout for src and thor
>   scsi: aacraid: check adapter health before processing IOCTL
>   scsi: aacraid: Issued AIF request command after IOP RESET
>   scsi: aacraid: Update driver version to 50983

Applied to 5.5/scsi-queue.

Zeroday had some additional warnings that were not introduced by this
series. Please review and address those. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
