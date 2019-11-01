Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF173CA9ECB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 02:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82CCF2086D
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 02:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A4MlLCoA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbfKACSJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 22:18:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43324 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfKACSJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 22:18:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA12DqWC169861;
        Fri, 1 Nov 2019 02:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=6rP8Vk0p4YHITodlZ6FD5T+hqAudKIaOiGlj0aK2i5A=;
 b=A4MlLCoARbYPT1+RbefZzVfzvIzVHPP9khDJ8YV0qEQHHLg+5zGyeaMCZIpUoHk9y45Y
 Euw5heKPIMFYon7NdYqbJ+ak6OtedysL7L8QQbJy6rRQyClY3QSF8BDpEg4PyIPmycOB
 9kH3DmvkG25xGYbKuOsp+kJEhlPMMTZ/bHDcUKyEoxg86nJL5felLUy/mnEeTUFhQQDB
 AZMwQgnh8h9j7sNQhTbSPd5LL/KpiMzlozFwsPICI4USaiemCXzYRytS8ap0tyQtdT5X
 gOw54LaNn4jiaeGWJeoPWoAydkaQhAMScZfwsijX+bJJXhxDa6BBLADlh/ouaHmCOzNv VA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vxwhfxwyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 02:17:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA12E1g7161243;
        Fri, 1 Nov 2019 02:15:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vykw2fqne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Nov 2019 02:15:47 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA12Ff9H024243;
        Fri, 1 Nov 2019 02:15:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Oct 2019 19:15:41 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/3] ufs: Fix kernel-doc warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191029230710.211926-1-bvanassche@acm.org>
        <20191029230710.211926-2-bvanassche@acm.org>
Date:   Thu, 31 Oct 2019 22:15:38 -0400
In-Reply-To: <20191029230710.211926-2-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 29 Oct 2019 16:07:08 -0700")
Message-ID: <yq1eeys5ol1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9427 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911010020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9427 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911010020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Fix the following three kernel-doc warnings:
>
> drivers/scsi/ufs/ufs_bsg.c:165: warning: Function parameter or member 'hba' not described in 'ufs_bsg_remove'
> drivers/scsi/ufs/ufshcd.c:5789: warning: Function parameter or member 'cmd_type' not described in 'ufshcd_issue_devman_upiu_cmd'
> drivers/scsi/ufs/ufshcd.c:5789: warning: Excess function parameter 'msgcode' description in 'ufshcd_issue_devman_upiu_cmd'

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
