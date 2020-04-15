Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53D8C2BB1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 01:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D16F206D9
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 01:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oFkSwqa4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733266AbgDOBft (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 21:35:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36406 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733236AbgDOBfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 21:35:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F1WcgS069284;
        Wed, 15 Apr 2020 01:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=SvzuiBhpnSq4v45HhbBUar1qA4ABlo4olz0Qg2Yf7kM=;
 b=oFkSwqa4KXlhXGXsujB4NmaN5NNg4WiHwFYuaR0c7sVLbxmtkpipaZNKQxIb8VF87/kw
 Z88HHTn4YJ/sZFnGdPnCJXXJ60mwT+UANO7Eo2ITIEwrHCK0x6No4P1jNog9OE2B0C+J
 sohfAruI15kSwNpX3XgVuN6zmeIGtgHGUFoKRSnqFtVHyGv7YEBbTwc27g9AEXBkB1TW
 vPRlUpBLQZMKcl5zoSxaCJnb4bRny5ExmCvPwj4tHs2wsuOGXI781ICrKGqiBTyUchrg
 mAQzb7CtlSNrC1nZv9rSQcHzqTId4Ez+G7XHqWZ53XB4qDb4HkA+HAxCxcx5IFfQk+Fj sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30dn9cgkqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 01:35:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F1Vll0160546;
        Wed, 15 Apr 2020 01:35:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30dn98fe4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 01:35:35 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03F1ZYmv018646;
        Wed, 15 Apr 2020 01:35:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 18:35:34 -0700
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <anil.gurumurthy@qlogic.com>, <sudarsana.kalluru@qlogic.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/7] make a bunch of symbols static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200407032202.36789-1-yanaijie@huawei.com>
Date:   Tue, 14 Apr 2020 21:35:32 -0400
In-Reply-To: <20200407032202.36789-1-yanaijie@huawei.com> (Jason Yan's message
        of "Tue, 7 Apr 2020 11:21:55 +0800")
Message-ID: <yq1d089r0nv.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004150008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> Fix some sparse warnings.
>
> Jason Yan (7):
>   scsi: bfa: bfa_svc.c: make two functions static
>   scsi: bfa: bfa_core.c: make bfa_isr_rspq() static
>   scsi: bfa: bfa_fcpim.c: make two functions static
>   scsi: bfa: bfa_fcs_lport.c: make bfa_fcport_get_loop_attr() static
>   scsi: bfa: bfa_ioc_ct.c: make two funcitons static
>   scsi: bfa: bfad_attr.c: make two funcitons static
>   scsi: bfa: bfad.c: make max_rport_logins static

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
