Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8FBCA9EAF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 01:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E882521D71
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 01:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jIBHVCHB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388791AbfJYBWQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 21:22:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40298 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388701AbfJYBWQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 21:22:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P1Jg3W124632;
        Fri, 25 Oct 2019 01:22:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=SPRaq8yaax6A3Fiu40xuZkAocPCF359sN02pM6RUdk4=;
 b=jIBHVCHBCiHpGBfO5uGzOZtK0SNDwtyjTLle2oJFxDQMeZIZkayyW1htRyHEUwAhXsTN
 utdahHXVB/MEBCfaEkFCF2OwBuDThixlu2m1TDccVKWKRuZjcaegRB3LW85c1v/YMVsj
 x/mF+QVcj8qmwzl50LPaXwttexUAArL7IOEkio17QaBXD4jnQw9Hu5zAhvzO+cCnrfO9
 lyGJXC/GMGAVqJQw4SDJrxR1kI8SAf6e0rWicscjxvlrqEQAxmM1BQghmdTI9LHzeWvz
 Dztweppb3btCAM0oHcz2+iUedCYA2ZPv2HGN2xCaMtkaceZryfX3ANwm1FTCxLbImdUi dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vqteq76e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 01:22:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P1J7gp040100;
        Fri, 25 Oct 2019 01:22:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vug0cs0pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 01:22:03 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9P1M1eX019156;
        Fri, 25 Oct 2019 01:22:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 18:22:01 -0700
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jiri Kosina <trivial@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] scsi: isci: Spelling s/configruation/configuration/
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191024152543.30310-1-geert+renesas@glider.be>
Date:   Thu, 24 Oct 2019 21:21:59 -0400
In-Reply-To: <20191024152543.30310-1-geert+renesas@glider.be> (Geert
        Uytterhoeven's message of "Thu, 24 Oct 2019 17:25:43 +0200")
Message-ID: <yq18sp9bow8.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250012
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Geert,

> Fix misspelling of "configuration".

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
