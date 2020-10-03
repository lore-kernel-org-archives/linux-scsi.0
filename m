Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90090C4363C
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 02:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CFE02074B
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 02:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BpVf7kQf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgJCCHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 22:07:54 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50706 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgJCCHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 22:07:53 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09320Y3l112035;
        Sat, 3 Oct 2020 02:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=rNpMb/Luq7ethTPNat+rlGaHRYlmWn1YKkvTCK6/g7o=;
 b=BpVf7kQfWMofHaeZoMGKxPAts47XVz/xktQXowOeBK2zHMVtVled18RcIRHejUeIM6SH
 BWzTnK6vHAWBH1LP/1Bg40A/2uaomLNCniCkoTlFbi24Wnqe5oYSWa68yt9j1B4HdLhh
 LzDSm5RalfsuZ5m4UYAbJse+Z4ScbDl21CRa2teGDGpUJjxwnnPWP2O3AuPSeKQQEE9C
 FyPJuv3luAALSvReF/u0R0Nrs6u4ZWqNgBRPObcFdMjYALwEdDVy5xrJkdJh5QjAOOFY
 zyaVis9IiX1MQym2dD8zKHNwIJ11J0n9438BSJbN3SVnSjI8IbnFygXMREzXORJdpymD hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetag38u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 02:07:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09320c2u001734;
        Sat, 3 Oct 2020 02:05:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33tfj3scjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 02:05:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09325g9l026329;
        Sat, 3 Oct 2020 02:05:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 19:05:41 -0700
To:     Ye Bin <yebin10@huawei.com>
Cc:     <james.smart@broadcom.com>, <dick.kennedy@broadcom.com>,
        <linux-scsi@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: lpfc: Remove Unneeded variable 'status' in
 lpfc_fcp_cpu_map_store
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sgawawt0.fsf@ca-mkp.ca.oracle.com>
References: <20200916022859.349089-1-yebin10@huawei.com>
Date:   Fri, 02 Oct 2020 22:05:39 -0400
In-Reply-To: <20200916022859.349089-1-yebin10@huawei.com> (Ye Bin's message of
        "Wed, 16 Sep 2020 10:28:59 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ye,

> Fixes coccicheck warning:
> drivers/scsi/lpfc/lpfc_attr.c:5341:5-11: Unneeded variable: "status". Return "- EINVAL" on line 5342

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
