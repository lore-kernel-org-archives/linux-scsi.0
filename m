Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D863C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 810A92075D
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZIvg0LxX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgHEBTo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:19:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53024 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgHEBTn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:19:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751I4Jc020308;
        Wed, 5 Aug 2020 01:19:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=4tCwTZEqvmRXthfZzrAj+2qhiRpSlWLseZqNH1gB0vg=;
 b=ZIvg0LxX0w4Q4OytG3NgSAiz6HDwHYpvMX2uKQdaLweDYg2r8jKjI7oMeAo45azEIMop
 weVfeDwQjtjGiO5Dj3h4hH0dUox3RwkD853HptQ11HLo1/db0Xh/cTSZ3WswZvesivZC
 vwx0YGk3e6nz3d3wVZ1LGFuPbOBLV0vZhpV4rrt5irq/PDDwS9l0NkwzWNOk/yn5U7l2
 EQ3MDpNhbEW3QH1gB8vz5zisGEZy+g0gX0xfa6/ld0AVuSbLpGvt3q34HEuYozscy1Rj
 7WCL7dvEcuDnkQ2LmkRNHz9rGJqWpXyTFXgDMESlCVy7OIyHpYhsElQLUURKU5TEbN1f fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32nc9ynyt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 01:19:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751917A177519;
        Wed, 5 Aug 2020 01:17:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32pdhd72ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 01:17:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0751Hdjw007531;
        Wed, 5 Aug 2020 01:17:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Aug 2020 18:17:39 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/8] lpfc: Update lpfc to revision 12.8.0.3
Date:   Tue,  4 Aug 2020 21:17:32 -0400
Message-Id: <159659019689.15726.87165415029440551.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803210229.23063-1-jsmart2021@gmail.com>
References: <20200803210229.23063-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 3 Aug 2020 14:02:21 -0700, James Smart wrote:

> Update lpfc to revision 12.8.0.3
> 
> Patch set contains several small fixes.
> 
> The patches were cut against Martin's 5.9/scsi-queue tree
> 
> James Smart (8):
>   lpfc: Fix FCoE speed reporting
>   lpfc: Fix no message shown for lpfc_hdw_queue out of range value
>   lpfc: Fix RSCN timeout due to incorrect gidft counter
>   lpfc: Fix oops when unloading driver while running mds diags
>   lpfc: Fix retry of PRLI when status indicates its unsupported
>   lpfc: Fix validation of bsg reply lengths
>   lpfc: Fix lun loss after cable pull
>   lpfc: Update lpfc version to 12.8.0.3
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/8] scsi: lpfc: Fix FCoE speed reporting
      https://git.kernel.org/mkp/scsi/c/a1e4d3d8aef9
[2/8] scsi: lpfc: Fix no message shown for lpfc_hdw_queue out of range value
      https://git.kernel.org/mkp/scsi/c/9e3e365a92d3
[3/8] scsi: lpfc: Fix RSCN timeout due to incorrect gidft counter
      https://git.kernel.org/mkp/scsi/c/8ccd6926db7d
[4/8] scsi: lpfc: Fix oops when unloading driver while running mds diags
      https://git.kernel.org/mkp/scsi/c/24411fcd6fe7
[5/8] scsi: lpfc: Fix retry of PRLI when status indicates its unsupported
      https://git.kernel.org/mkp/scsi/c/678768da9880
[6/8] scsi: lpfc: Fix validation of bsg reply lengths
      https://git.kernel.org/mkp/scsi/c/feb3cc57fb63
[7/8] scsi: lpfc: Fix LUN loss after cable pull
      https://git.kernel.org/mkp/scsi/c/00081c5ca4d5
[8/8] scsi: lpfc: Update lpfc version to 12.8.0.3
      https://git.kernel.org/mkp/scsi/c/7e0e8be3a1fd

-- 
Martin K. Petersen	Oracle Linux Engineering
