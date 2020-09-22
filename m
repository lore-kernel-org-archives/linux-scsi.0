Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CA4C2D0E2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8066C23A34
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HDatyPQ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgIVD5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:52 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42178 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbgIVD5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3nUXE149216;
        Tue, 22 Sep 2020 03:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=mpo3+iZVocB7HppUPei8VHyCBtZ8fey5VuFt907OYSY=;
 b=HDatyPQ8lT27dwmM5okiQo71Xju/gzFmT76ZKDU4CX5vuqfslQ4j3xMAMGPVS8L4Esnf
 IOz1/qR4biKhRl7hZzDAg18Ced4CPpDmFD0h/vcr0Vw9sQNm/Rp74Nq1dxwHPn/B/ixV
 B78YNG470dSLqm6O6oRDteHko64uuKtpEvabdQ0O5qmifyJXMYpt6LZl5WGgUqQ96VG0
 KnctWqHZjQuooYYGJWiX09jeJGNESZ7rJlJvlvV6dx+JKEUxHN3uF3oqt1PcBdMvGaiU
 FgAqQ28ePOqNNG1PO7qrx9lGabYQuCGY9bzm1aIEdn1dpH+Q94qNqHBD0zed09bK4Xx5 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33n7gad5ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3tKsT020609;
        Tue, 22 Sep 2020 03:57:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33nuwxk76r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:34 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vXeE009585;
        Tue, 22 Sep 2020 03:57:33 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:33 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        hare@kernel.org, gustavoars@kernel.org, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: myrb: make some symblos static
Date:   Mon, 21 Sep 2020 23:57:02 -0400
Message-Id: <160074695011.411.8296378629695152671.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915084018.2826922-1-yanaijie@huawei.com>
References: <20200915084018.2826922-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=899 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=913 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Sep 2020 16:40:18 +0800, Jason Yan wrote:

> This addresses the following sparse warning:
> 
> drivers/scsi/myrb.c:2229:27: warning: symbol 'myrb_template' was not
> declared. Should it be static?
> drivers/scsi/myrb.c:2318:31: warning: symbol 'myrb_raid_functions' was
> not declared. Should it be static?
> drivers/scsi/myrb.c:2492:6: warning: symbol 'myrb_err_status' was not
> declared. Should it be static?

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: myrb: Make some symblos static
      https://git.kernel.org/mkp/scsi/c/9d8a5510281c

-- 
Martin K. Petersen	Oracle Linux Engineering
