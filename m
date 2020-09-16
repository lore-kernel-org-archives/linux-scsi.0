Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDC2C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 01:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3956621D1B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 01:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CrkOcsBC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgIPBb4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 21:31:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbgIPBbx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 21:31:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G1UQcN019265;
        Wed, 16 Sep 2020 01:31:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=V/JBji6veS5A63ohURKYjeQ/jbs789i+bwH/C4Lyzh0=;
 b=CrkOcsBCFtWSypGfMaGZSb1cV9frPjn93MxDqvNaIhR7h6UJ6z91Ah4NEj3YKM0FvzLU
 L4ghuy3Raoxjsy0aqjiRdiHpAkhqB2l1lhDoh+fXQdEGU8MgDxNuf0ltD+RPJxbnFcHB
 nnBFb82yDlAaTUHz04wMkPh6CNQlzgFLR1hb9rWOF1arod//70iU7WXnB/5HAWkqAbOZ
 QYl8Z4ivV5gce9v1PDOCzHNzYGCOLXWChJR2wtTTKu70NIF5gUzsn86q5IqL+t4KyZCw
 MHDV/qZf77zwPXFry0dnJOAQ3PEo9oEHk3VHjHqQCWeCDrbh2z+ByzAQwPQ6rxM2uW7U hQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33gnrr0au8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 01:31:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G1TwSU062994;
        Wed, 16 Sep 2020 01:31:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33h7wq1k37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 01:31:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08G1Vdmd024326;
        Wed, 16 Sep 2020 01:31:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 01:31:39 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <hare@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <lee.jones@linaro.org>,
        <linux-scsi@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: myrs: make some symbols static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1imcezevi.fsf@ca-mkp.ca.oracle.com>
References: <20200915084008.2826835-1-yanaijie@huawei.com>
Date:   Tue, 15 Sep 2020 21:31:36 -0400
In-Reply-To: <20200915084008.2826835-1-yanaijie@huawei.com> (Jason Yan's
        message of "Tue, 15 Sep 2020 16:40:08 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=962 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1011 mlxlogscore=977 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160006
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> This addresses the following sparse warning:
>
> drivers/scsi/myrs.c:1532:5: warning: symbol 'myrs_host_reset' was not
> declared. Should it be static?
> drivers/scsi/myrs.c:1922:27: warning: symbol 'myrs_template' was not
> declared. Should it be static?
> drivers/scsi/myrs.c:2036:31: warning: symbol 'myrs_raid_functions' was
> not declared. Should it be static?
> drivers/scsi/myrs.c:2046:6: warning: symbol 'myrs_flush_cache' was not
> declared. Should it be static?

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
