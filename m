Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0416CC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 03:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1D18204EC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 03:09:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QTdX0++v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfKMDJJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 22:09:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45796 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbfKMDJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 22:09:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD34FXO093145;
        Wed, 13 Nov 2019 03:07:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=kQPUHp28mZSCANckys01a+OkgTW2WIhmzat0lXN2ydI=;
 b=QTdX0++vkHxdowb+G3vMnYMi1zQYfmwHAG6U5Hc42SUm8IoxeehnsMCn1LDQZ3yGJ1IF
 zsoafoK0xaeka5tlc8fQHRUkBp2TzYJ49pd7nhsMe3EM5othCRl8bvMQoSCyFrBaoR+8
 tImNuungObSWb1QqRhzhmblXH7n/chy0f4XD+yO5kpLRjx/XT6lVg2uHL5YwHfI80NnX
 6jPc3rBGdYNGIOuqEzlz2gnk8Q8lv1KQxdzsqhvCVQ5Tn9JF616vQb8Q+CltWkTtrMl1
 Cd8kHEE5/tO/oCFxaS6FN6pfR/fVsprMVBYGjEtTdIbjl85i5Pbo8+f2TZgQFlbuypJo gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w5ndq95sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 03:07:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD34DWq170512;
        Wed, 13 Nov 2019 03:07:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w7vbc1hmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 03:07:11 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAD37AFL029187;
        Wed, 13 Nov 2019 03:07:10 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 19:07:09 -0800
To:     Johan Hovold <johan@kernel.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: nsp_cs: MODULE_LICENSE clean up and compile test
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191105085609.2338-1-johan@kernel.org>
Date:   Tue, 12 Nov 2019 22:07:07 -0500
In-Reply-To: <20191105085609.2338-1-johan@kernel.org> (Johan Hovold's message
        of "Tue, 5 Nov 2019 09:56:07 +0100")
Message-ID: <yq1pnhwpj8k.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=946
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Johan,

> We had two drivers in the tree needlessly checking whether
> MODULE_LICENSE was defined, this fixes the second one.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
