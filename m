Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D8FC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B8602311B
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BT0qt+tc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732641AbgFTD1C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 23:27:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58752 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732629AbgFTD1B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 23:27:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3IXU3194488;
        Sat, 20 Jun 2020 03:26:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=PF84+gWPFaJNdwDpeizHfentgldpxqhtBTI+d6ZBfuM=;
 b=BT0qt+tc6qfjaZXXBP1CxgHKRKdWtr4bi40pftvAezuG/T58SvV25XVG0FwQXd7WSK66
 Oa+lbZsqPLpb4fgUip1qB9+jrl4nmQQpcW5rzRft6I+BU70rV0qvYWjLO50nXixBn0MC
 U26zhkmQ+WVKUcjUurKCMsHCLy3dNMaH5Cn+ollb6OywDNdP98yz38mvOfCdGQ2G2hDQ
 8dZrtxDBokGC79EfdJA7Roxu4J8OQ/dMNAzraTRQX98F98pPGqmZICYbJC2OEkc1di8z
 06nIzObYzRJnYYMpzDHGu2Iz32xkPfxK/MBEpKue+pEsXD8fseVlJ3zMLwVsFyuUqwUN 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31s9vqr1vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 20 Jun 2020 03:26:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3Jc0p005666;
        Sat, 20 Jun 2020 03:26:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31sa8yh28f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Jun 2020 03:26:44 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05K3Qggp002429;
        Sat, 20 Jun 2020 03:26:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 20:26:42 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Avri Altman <avri.altman@wdc.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Colin King <colin.king@canonical.com>,
        Seungwon Jeon <essuuj@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kukjin Kim <kgene@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][next] scsi: ufs: ufs-exynos: fix spelling mistake "pa_granularty" -> "pa_granularity"
Date:   Fri, 19 Jun 2020 23:26:36 -0400
Message-Id: <159262354734.7800.18123945491973468082.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617084911.167359-1-colin.king@canonical.com>
References: <20200617084911.167359-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=960 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 malwarescore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=983 mlxscore=0 phishscore=0 cotscore=-2147483648 spamscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006200022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Jun 2020 09:49:11 +0100, Colin King wrote:

> There is a spelling mistake in a dev_warn message. Fix it.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-exynos: Fix spelling mistake "pa_granularty" -> "pa_granularity"
      https://git.kernel.org/mkp/scsi/c/393403efc360

-- 
Martin K. Petersen	Oracle Linux Engineering
