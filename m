Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2048DC4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E656C2225E
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbhAMFtn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:49:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbhAMFtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:49:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5hrpM096106;
        Wed, 13 Jan 2021 05:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZkHrcYYV5Akk6uzT+EdKBUBcNo8KiHkTc+tKaCmAVFk=;
 b=Wyp7IYKwOIvT64CBbNSyB65TGDFvs0W78C4DuwGnJ5YYC6P/lmGf1ZZ4f6qf35Cl5gRc
 8Cf9HlSD6IbEfEkU0WFH2WKXN785UvvvVOkti7TgWNZtjMWFTEdFJd4MfONyOrSTnr4N
 HYZd/ncw7KQc/6MSOR2AgOuJOQWHn1/FbwaGNIVKNHvegBBkKuAl1OW9HhSNDarnmNvN
 2IpWl6JrSFWXiGqX4DZajqtC2xNY8NwG/SB+cQllbecDj2W8lMR9i0jezWjOpm+tHVrH
 7HsYr/iQWpzDI4B7gaCqqgTwM2a25/Qv9v83i/HCe0/WqQHr+4lUR5BZH/79o2f3DFDu Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 360kcysp29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:48:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5eVSw058726;
        Wed, 13 Jan 2021 05:48:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 360kf6w0j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:48:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10D5mvRS023930;
        Wed, 13 Jan 2021 05:48:58 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 21:48:57 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: docs: ABI: sysfs-driver-ufs: rectify table formatting
Date:   Wed, 13 Jan 2021 00:48:53 -0500
Message-Id: <161051681546.32710.5582070513683033836.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111102212.19377-1-lukas.bulwahn@gmail.com>
References: <20210111102212.19377-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130034
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 11 Jan 2021 11:22:12 +0100, Lukas Bulwahn wrote:

> Commit 0b2894cd0fdf ("scsi: docs: ABI: sysfs-driver-ufs: Add DeepSleep
> power mode") adds new entries in tables of sysfs-driver-ufs ABI
> documentation, but formatted the table incorrectly.
> 
> Hence, make htmldocs warns:
> 
>   ./Documentation/ABI/testing/sysfs-driver-ufs:{915,956}:
>   WARNING: Malformed table. Text in column margin in table line 15.
> 
> [...]

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: docs: ABI: sysfs-driver-ufs: rectify table formatting
      https://git.kernel.org/mkp/scsi/c/f2cb4b2397ca

-- 
Martin K. Petersen	Oracle Linux Engineering
