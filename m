Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5B6C35257
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 02:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBFEC20719
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 02:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GWjRaUuG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgJCCAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 22:00:37 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44898 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgJCCAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 22:00:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09320AeR111994;
        Sat, 3 Oct 2020 02:00:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=JofXljxaqXtZQQY/bD0ZkjNTs13Wo8bE5x+qeji27bg=;
 b=GWjRaUuGZRfsHNNXipk0gvq4VSl5N9tcpRQjgvd7fBAEorVYEvAdfCV8orZIf4flvJbG
 1ciis+igAuksSwLFAvZCLGX6otgpwzg/gyoyCHrk4GoWI/G2pkxMLE7QWZBa+D4bqgrl
 4WfKPfE/0M/wBhKRmCtuj5AvdO9Ya4DnxHCRBVPj77xCKa2Jj7YKJo0+0bbLPrLyajPe
 75oMutwJgO3XWlZQH4szQL+yJ6agJ8YHwehmrUufPdLcAQmq5LOlffPfWZMn1YQ0Wl/H
 Yv4A7A0kSttTCG7f6EtOs1eEw2j0AuIjxbp+CRFQdh1ThSylLSaI0OFxaqDFKD2PgmvF MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetag2ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 02:00:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931p2kE037199;
        Sat, 3 Oct 2020 01:58:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33xfb8grj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 01:58:25 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0931wNKC010029;
        Sat, 3 Oct 2020 01:58:23 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 18:58:23 -0700
To:     Ye Bin <yebin10@huawei.com>
Cc:     <njavali@marvell.com>, <mrangankar@marvell.com>,
        <linux-scsi@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: qla4xxx: Delete unneeded variable 'status' in
 qla4xxx_process_ddb_changed
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14knccbpk.fsf@ca-mkp.ca.oracle.com>
References: <20200916022749.348923-1-yebin10@huawei.com>
Date:   Fri, 02 Oct 2020 21:58:21 -0400
In-Reply-To: <20200916022749.348923-1-yebin10@huawei.com> (Ye Bin's message of
        "Wed, 16 Sep 2020 10:27:49 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ye,

> Fixes coccicheck warning:
> drivers/scsi/qla4xxx/ql4_init.c:1173:5-11: Unneeded variable: "status". Return "QLA_ERROR" on line 1195

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
