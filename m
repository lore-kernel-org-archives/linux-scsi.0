Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7704C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 05:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 827282463B
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 05:56:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="no/bZBfZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgKQFz7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 00:55:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44862 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgKQFz7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2020 00:55:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH5oGCL103955;
        Tue, 17 Nov 2020 05:55:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=XrT7x1ZlUCIcIw69duUraHnPzjHwxlu/NNf/mTwVUxw=;
 b=no/bZBfZj9ILRtb3KqW+8xKpD4rWqqroB6W99hZlaIruixMwuILoo0ceSOsOqbzoVhjn
 PK6RSCKRFyxuky2i8bpVGFxFwYgtDlkRgO/bf25mwvfFFAelYvfS670BhX9Vu6nDJvDC
 y8BVv2VZHI83ne0j58sXm63zr+CnwaPv3UEX0fsB2wELh4c2iGUkTbTSZUc+hD7Ny8dN
 N2c0nPl8lhuAfN7RGPYZ2hWlWaJgNA42DGPwUh317Tl4Jdq2gEoK7Np800krnfaiYdSG
 0dNULHmLvjl8+dbq8rCrwxbWMIGbfpFplh2VRXlT0wgtZsTREbc+fRf3Sg4w/HA+a0Bp kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34t4rarst6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 05:55:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH5pQWc046735;
        Tue, 17 Nov 2020 05:53:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ts0qe4ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 05:53:51 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AH5roOJ008613;
        Tue, 17 Nov 2020 05:53:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 21:53:50 -0800
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla4xxx: Remove redundant assignment to variable
 rval
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8jw34ww.fsf@ca-mkp.ca.oracle.com>
References: <20201103120137.109717-1-jingxiangfeng@huawei.com>
Date:   Tue, 17 Nov 2020 00:53:48 -0500
In-Reply-To: <20201103120137.109717-1-jingxiangfeng@huawei.com> (Jing
        Xiangfeng's message of "Tue, 3 Nov 2020 20:01:37 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=1 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170043
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jing,

> The variable rval has been initialized with 'QLA_ERROR'. The
> assignment is redundant in an error path. So remove it.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
