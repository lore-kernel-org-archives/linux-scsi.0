Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B707C432C2
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 02:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50CE220882
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 02:58:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lnN6jdm8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408860AbfIXC6P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 22:58:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46134 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394615AbfIXC6P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2019 22:58:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O2s954133498;
        Tue, 24 Sep 2019 02:58:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=QQiRgXEC9eGXr0NFS4DSWp9hl6tQZHo9QzbnasT8fgE=;
 b=lnN6jdm8IptLvQ7gAqKAyA+pu7a23z/2jVvZWTC6XuysArBxZYZWgC3t3GiF54pyo9Sc
 83YzSzBI4SktuLIBYN3uxgpqthkc45TC6ddNBoaHSbI6BC1tzabsWfeIpFt8HmDrbtB1
 Llm5a/gYYxUl6QP12TQmr4JGZmY+pblttU7rVaOVRsjY8soS4ncPg5ZevL2cJKVo1PPd
 /RF8unDlvZNKzXa33ZCBgF3hULm5MuIAyVtYanG4NKU400Jhm2rB8dTudgGHc86uU5Ck
 RmVnmD1sjGZxDtfUVJhAwA0S+GOrlYzYp8AnVymNwFC0nqOvCVsr4EtILXSEXCpdSw5c 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tjy34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 02:58:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O2slNp173776;
        Tue, 24 Sep 2019 02:58:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v6yvqpjf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 02:58:08 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8O2w69l026788;
        Tue, 24 Sep 2019 02:58:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 19:58:06 -0700
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: hisi_sas: Make three functions static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190923054035.19036-1-yuehaibing@huawei.com>
Date:   Mon, 23 Sep 2019 22:58:03 -0400
In-Reply-To: <20190923054035.19036-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Mon, 23 Sep 2019 13:40:35 +0800")
Message-ID: <yq1blva4czo.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=956
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240028
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


YueHaibing,

> Fix sparse warnings:
>
> drivers/scsi/hisi_sas/hisi_sas_main.c:3686:6:
>  warning: symbol 'hisi_sas_debugfs_release' was not declared. Should it be static?
> drivers/scsi/hisi_sas/hisi_sas_main.c:3708:5:
>  warning: symbol 'hisi_sas_debugfs_alloc' was not declared. Should it be static?
> drivers/scsi/hisi_sas/hisi_sas_main.c:3799:6:
>  warning: symbol 'hisi_sas_debugfs_bist_init' was not declared. Should it be static?

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
