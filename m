Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836C2C388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 03:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3370F207BB
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 03:38:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VenRGGBv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgKKDim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 22:38:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgKKDil (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 22:38:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB3Tufo035525;
        Wed, 11 Nov 2020 03:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=6Ldw9+nA2cvl8Q2mg9MGzlht3K6KXi9j1Nfh6Z2Aaj8=;
 b=VenRGGBvbG1avptpwoT9vELG0tYkr+2Vm6z/Qlg9/7siPTyoY7Me+OE1pNZL4KFy39M1
 Gku8fkMxAWoic1pziDixv7ksSxitzL+c1LARK0ZLNv2jKaYW0vkeeOomGDJ458/foEj5
 6h60Snm7xQjCusEwFOdA33FYSiJheKkhQkWVTuWflXRkySiMIuZYJPyrNTqrJeoQt4ni
 nwSoMLHGa7IHzeGETyXlfbnV9+H56FjUMDjZ9xajFxThZowzpnNOiBJUhvNZ1DllQaoZ
 6g06UHYVJ8Ww+HUSx6mWgvfk/6wpZAOzGU8G7Q6DX+2wU/q19eKz8hUfK41DXGOm573D Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34nkhky06e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 03:38:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB3P60q068257;
        Wed, 11 Nov 2020 03:36:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34qgp7qp0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 03:36:37 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB3aaIp022893;
        Wed, 11 Nov 2020 03:36:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 19:36:35 -0800
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: [PATCH 1/1] target_core_user: make Bodo maintainer
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg9gfttx.fsf@ca-mkp.ca.oracle.com>
References: <1604521666-16573-1-git-send-email-michael.christie@oracle.com>
Date:   Tue, 10 Nov 2020 22:36:33 -0500
In-Reply-To: <1604521666-16573-1-git-send-email-michael.christie@oracle.com>
        (Mike Christie's message of "Wed, 4 Nov 2020 14:27:46 -0600")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=880
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=1 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=910 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> Bodo knows the code better than me now, has time to review
> patches and is excellent at it, and has lots of ideas for how to
> make the driver better, so this patch adds him as the maintainer.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
