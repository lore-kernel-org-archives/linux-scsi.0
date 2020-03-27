Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF9EC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2D9B2074A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uoVQ7YM3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgC0Qyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 12:54:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33688 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgC0Qyz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 12:54:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RGrOXZ016755;
        Fri, 27 Mar 2020 16:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=22CyXLswtAzoWLXbJG3I6Plai67F2MsyesqnvTqMo4M=;
 b=uoVQ7YM3x/l5t0RD7p4pt6sTUMsW2m72x90XCRUB63ax4M4QRRKnKSFSkkJUxvmNtL8i
 2Ke/cP4Y/UqiWJuE0ZISnNwBQQlDfwUx8GTaIHMjYmhf9K+TjaiXca0K+mTJdeilzaX/
 TDBooIKxskuYlqxcaEieShChIrFr8/vomIKR/nxGg7pqP69Uy7cM/6A00Hxvqd7/SfLR
 uWW19iPthZSXT5sYC6izs3hR8XCZ5q3CRtQl3nkK1d8sy7hJt2DF3AlPc6/C1K8uCXqr
 8jKyrOFHuqxz+Ju3WEnREXk2pdtKzscnEwND8Ricn3mqR/j755pHjUa5JL0PzHxBOZ2Z KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 301m49gf5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 16:54:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RGqFA9139466;
        Fri, 27 Mar 2020 16:54:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3006ram276-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 16:54:52 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02RGsp5p018963;
        Fri, 27 Mar 2020 16:54:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Mar 2020 09:54:51 -0700
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 0/3] qla2xxx: Updates for the driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200327143248.27288-1-njavali@marvell.com>
Date:   Fri, 27 Mar 2020 12:54:49 -0400
In-Reply-To: <20200327143248.27288-1-njavali@marvell.com> (Nilesh Javali's
        message of "Fri, 27 Mar 2020 07:32:45 -0700")
Message-ID: <yq1wo75buw6.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=769 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=846 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270146
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Nilesh!

> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.

This is missing a changelog. What actually changed in patch 1?

Also, assuming patches 2 and 3 are unchanged, they are missing
Himanshu's review tags.

-- 
Martin K. Petersen	Oracle Linux Engineering
