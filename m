Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675EBC433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 01:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 307FA20936
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 01:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lm0V6t6T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIPB2c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 21:28:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46838 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgIPB23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 21:28:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G18vaL072911;
        Wed, 16 Sep 2020 01:28:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=hBR9Val3W1L1tavXXmAN4DkCzsNvTHmN3gsuVZ/Lsuk=;
 b=lm0V6t6Ts4tZOVE/e+niRYJKgBdFqoqyhAxMpT4hM3MyYhzLqSTfjGFeyTgZhIBilRk0
 nnwHSGJuAOHgYfIDSs0UkZ6P80vQvFWyGKG0HtNkRXJ/F5qZyCMz9nlO67vYr1Vjd9TM
 JHt3/YbKtWDmGtGAbCp9USvgsN9OsRUc9qZOrAfRmCkbuhOXBaFhIOVXYBHrEmegBbL0
 nH9viwiE0tK1iZO/UwDl5Hz/7MFY8wmh2+BkqFRmDA1urHF6mOakWcsK4m7YGRG1UNRV
 twlQBABEtg0niKEir6dVFgaw4TC6ijwryQBLdogrJtaYCdW+gBb8BlKmfWfyv4OABBkV Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9m89aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 01:28:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G1QHpb056570;
        Wed, 16 Sep 2020 01:28:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33h7wq1bf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 01:28:19 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08G1SH0U021062;
        Wed, 16 Sep 2020 01:28:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 01:28:17 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <aacraid@microsemi.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: aacraid: make some symbols static in aachba.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z8e1peg.fsf@ca-mkp.ca.oracle.com>
References: <20200912033749.142488-1-yanaijie@huawei.com>
Date:   Tue, 15 Sep 2020 21:28:14 -0400
In-Reply-To: <20200912033749.142488-1-yanaijie@huawei.com> (Jason Yan's
        message of "Sat, 12 Sep 2020 11:37:49 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=904 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=931
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160005
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> This eliminates the following sparse warning:
>
> drivers/scsi/aacraid/aachba.c:245:5: warning: symbol 'aac_convert_sgl'
> was not declared. Should it be static?
> drivers/scsi/aacraid/aachba.c:293:5: warning: symbol 'acbsize' was not
> declared. Should it be static?
> drivers/scsi/aacraid/aachba.c:324:5: warning: symbol 'aac_wwn' was not
> declared. Should it be static?

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
