Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C27C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 05:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12BF8241A5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 05:45:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iF+VdaK1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgKQFpX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 00:45:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51242 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQFpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2020 00:45:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH5iDLj133122;
        Tue, 17 Nov 2020 05:45:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=3do12q+Fef3HIeUDi9JvNNhs5PWgG2/7AcR7fMhFeJY=;
 b=iF+VdaK1crSdFpQB8N4eRnNBgFc7iKr1wcJXNEPVbszxqz/YaFRnPwCgXHX7EyKtQQ+f
 alj/Z6ucxCt5J44C0zz+OKEar/PhiRpSLSFDPywTiFbcQNAcoX3C97W4WpgS0/FQo/r6
 AwcdEbyPHO7mSzIRmtocfNO0BYCKTZdlSXMnfbQRyT4/Cy0W/2tqE8i38adNw3oqnsga
 43NXatuLyhh11FzO64H0u+Z64v1XWUwkgQZrEXKoe3eJqYV1Opt4c65jxcV9FpRhF3hw
 qdi1+hletj9BCeVi63srn2UnNZrrJGgGek/RTlyQ5d8dqHyqbHb0MZfZiosyp4kMT6/c EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34t76krmtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 05:45:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH5fExL097848;
        Tue, 17 Nov 2020 05:45:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34umcxqmy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 05:45:20 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AH5jJES004654;
        Tue, 17 Nov 2020 05:45:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 21:45:19 -0800
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/17] lpfc: Update lpfc to revision 12.8.0.6
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zh3g35ay.fsf@ca-mkp.ca.oracle.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
Date:   Tue, 17 Nov 2020 00:45:17 -0500
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com> (James Smart's
        message of "Sun, 15 Nov 2020 11:26:29 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170042
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 12.8.0.6

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
