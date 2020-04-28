Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8EDC83003
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 00:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B49922070B
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 00:35:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W7P8x6Ns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgD1Ae6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 20:34:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34082 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgD1Ae6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 20:34:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03S0KDrl167389;
        Tue, 28 Apr 2020 00:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=KEEfHil6dnSLFm1q3xH4L9RLhoQa558GuexLsXCTxaQ=;
 b=W7P8x6NsLSItJeUUvbFhtmXR8iilOawP5GIZiJ1vbYC8qoQDzgZObbAaQ/XVdqtyE8n0
 gOERLM/qlzbAX+M76gL2qCl06PlixtuzNthzaX0L41DwEAIC69TDqT+J9UYSZRskJzfH
 YKFXUOB3Cho3WkMhn/mYNnsQL9yxuU67Y2zihv9yG1LeNbTlQuuntocKhHc8QRhOUHJ7
 CRuClDoE/cm9ONOKoejBSar9BTtLCQ0JqkoRxlDMFbqOGZpVDp6kodwShTt6ynwrIr8g
 +UFOmcWT1a+peOFuvWHDurKHS8qwFRAngYK6GGWQZGSqClNCy1YeGjj20CY2n73CsxXX +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01nkabj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 00:34:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03S0Gvbq190574;
        Tue, 28 Apr 2020 00:34:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30my0b4r81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 00:34:53 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03S0YpxO030137;
        Tue, 28 Apr 2020 00:34:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 17:34:51 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel@collabora.com, jejb@linux.ibm.com
Subject: Re: [RESEND PATCH v2] scsi: core: dox: Change function comments to kernel-doc style
Date:   Mon, 27 Apr 2020 20:34:50 -0400
Message-Id: <158803405340.29157.1656152074751746659.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200419050148.33371-1-andrealmeid@collabora.com>
References: <20200419050148.33371-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1011
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280000
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 19 Apr 2020 02:01:48 -0300, =?UTF-8?q?Andr=C3=A9=20Almeida?= wrote:

> Despite of functions being documented, they are not in the kernel-doc
> specification, and could not be included in kernel documentation. Change
> the style of functions comments to be compliant to the kernel-doc style.
> When the function comment is outdated, update then.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: core: doc: Change function comments to kernel-doc style
      https://git.kernel.org/mkp/scsi/c/ea941016abf7

-- 
Martin K. Petersen	Oracle Linux Engineering
