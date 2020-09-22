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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49EF4C4727C
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 123A723A5B
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wcG4a1em"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgIVD5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48534 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728574AbgIVD5i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3n8ts077354;
        Tue, 22 Sep 2020 03:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=EqJIWS90fr+T7UjGCtmiIFJN7Tz4DkNga4Vn0M4MM+8=;
 b=wcG4a1emmfDTIcvnShnR8RJSpN0ru9kb/miNGMPI266mNMokDuSsxAclO7gyIlk1IDvd
 iwniIuaDynRcQ6zJy+Uf+EhgeZfj93362mA83xeqxVlDywXI7jxuAFF77SoCwdwp9/Sy
 xoVm1NbAaofg+jZ7KhbWFotiaatDmSENDQlnT5PLYC2NRvNXKm+3poIv6x67IgNqRY3M
 aqkInxXYeb47gcHN2GyK9mxE5+P312U97EhBsPiQhk/AUIHUDq+Od4hqCe6o0fVL9HMR
 GY3fcZnnHl2P+kAm0kCiECXEn7KXUTX6pmnRYA7EMldQftXr6aGaO3wkAaDK66NTE9IJ oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33q5rg8t78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3uTkM149952;
        Tue, 22 Sep 2020 03:57:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33nujmm8rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08M3vU5T019218;
        Tue, 22 Sep 2020 03:57:30 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:30 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, intel-linux-scu@intel.com,
        Jason Yan <yanaijie@huawei.com>, artur.paszkiewicz@intel.com,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: isci: make scu_link_layer_set_txcomsas_timeout() static
Date:   Mon, 21 Sep 2020 23:57:00 -0400
Message-Id: <160074695011.411.14380411989562639491.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915084000.2826741-1-yanaijie@huawei.com>
References: <20200915084000.2826741-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Sep 2020 16:40:00 +0800, Jason Yan wrote:

> This addresses the following sparse warning:
> 
> drivers/scsi/isci/phy.c:672:6: warning: symbol
> 'scu_link_layer_set_txcomsas_timeout' was not declared. Should it be
> static?

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: isci: Make scu_link_layer_set_txcomsas_timeout() static
      https://git.kernel.org/mkp/scsi/c/2494ebe1b3f7

-- 
Martin K. Petersen	Oracle Linux Engineering
