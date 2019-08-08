Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B98C32751
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E93FE21872
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:49:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QyB6SfiL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389645AbfHHBtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 21:49:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52318 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389618AbfHHBtY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2019 21:49:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781mbKF137539;
        Thu, 8 Aug 2019 01:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=lbwOscCzzhXf0JZx8jMWwDmgzCPBagTpzuG1ubVC2NU=;
 b=QyB6SfiLXF6W/sGOpl9eKFIrlWqYGDSTIFoO4v8pHvkwWD+neCoYwXAcDlQgHe36iGa+
 02ndCa3io87gz1ZRaQtliiE+VgcMW8Fl917ULuU94kETNbZKSUM8F6MYhFcXUzytpzwM
 Kqi79gSf4KimG5tiNeWddI6+bZeiBNltd0dCPCicCkquaCRLWhyTySAm5ITS7qdScDl+
 fzp7PltoLjzOXrQHyFJLsDSSm5d3K+0M3WilMJtxC9An0WNzy7f6ZC3Yw4GGPVQ656lM
 UWzUvsz1xl6VsEjbxcw47fr665LcDiZ9s9SMVHDhcr1dRSbPtxKitG2nSomlty0/sQ3/ 9Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u527pygsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:49:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781lvH6143017;
        Thu, 8 Aug 2019 01:49:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u76689xqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:49:16 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x781nE8L001720;
        Thu, 8 Aug 2019 01:49:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 18:49:14 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/3] SCSI core patches for kernel v5.4
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190801223814.140729-1-bvanassche@acm.org>
Date:   Wed, 07 Aug 2019 21:49:12 -0400
In-Reply-To: <20190801223814.140729-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 1 Aug 2019 15:38:11 -0700")
Message-ID: <yq11rxwe89z.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080016
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> The patches in this series address SCSI device blocking and unblocking
> and fix a boot failure. Please consider these patches for kernel
> version v5.4.

Applied to 5.4/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
