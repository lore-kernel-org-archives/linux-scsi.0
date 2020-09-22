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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6F4C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 397D123A32
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:59:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ukwbl2QP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgIVD7u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:59:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42750 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgIVD7t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:59:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3xSO3159665;
        Tue, 22 Sep 2020 03:59:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=BlB4SirmUzT+hbV8tdiNS/jKLeEqpu5Vcyw29ARym40=;
 b=ukwbl2QP86ushK48191q+k+94FMGyVa1bu9RR1i9Vt0ybY8scdTQb0JxaUWHhlq8Im9b
 oqnogoYgWgYG7Zjo+7vbVJ30V0L4hHtN2PSNFfXUv86y5AYfASr5W3EkjOJOhfendPvW
 BIyfWXM/eGT4bMA1WQN3necmpae8uhqHVS5tKgUlo6rPPDMdhhTKAWVbcPw8qFI9KoTT
 f2p6vhmEdUWuGWO0222WV7UbB1MJRXGkCJU7IJceN4f3e3I9aTPqwcfo4K3e9wyojZUD
 saZ/4JKlKrwcrZUAqDBhL+teIz64/HZQmfDR3CDytPTGqme6Pf6oqBLldeBJMppKYNK6 mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33n7gad5yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:59:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3uLVa073541;
        Tue, 22 Sep 2020 03:57:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33nurs30x5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:27 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vPac032582;
        Tue, 22 Sep 2020 03:57:25 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:25 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        hare@suse.de, aacraid@microsemi.com, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: aacraid: make some symbols static in aachba.c
Date:   Mon, 21 Sep 2020 23:56:56 -0400
Message-Id: <160074695010.411.572643806473768937.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200912033749.142488-1-yanaijie@huawei.com>
References: <20200912033749.142488-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=863 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=877 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 12 Sep 2020 11:37:49 +0800, Jason Yan wrote:

> This eliminates the following sparse warning:
> 
> drivers/scsi/aacraid/aachba.c:245:5: warning: symbol 'aac_convert_sgl'
> was not declared. Should it be static?
> drivers/scsi/aacraid/aachba.c:293:5: warning: symbol 'acbsize' was not
> declared. Should it be static?
> drivers/scsi/aacraid/aachba.c:324:5: warning: symbol 'aac_wwn' was not
> declared. Should it be static?

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: aacraid: Make some symbols static in aachba.c
      https://git.kernel.org/mkp/scsi/c/571e15688628

-- 
Martin K. Petersen	Oracle Linux Engineering
