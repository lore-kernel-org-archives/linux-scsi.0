Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5938C2D0F2
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 01:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D1F9208E0
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 01:08:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I5m9B1hP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgC0BIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 21:08:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46860 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbgC0BIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 21:08:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R14pkL006254;
        Fri, 27 Mar 2020 01:07:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=daNWGzIqn2PynbOV0oVeRZwzYhMM9U6tNzL39tmUQ0M=;
 b=I5m9B1hPmlikct71b48/T745x2IYFEl1tkVbOOAht2rEFOuvz3SHtqktPjrZMTB+f9H4
 25HrKH7AwPqSWLR5GXHg4OiFX2+0q0RATgmy0J3XTnLq03W9q6ULKOolghR94O3WGRtR
 1pRuGM6v+W+X7d6GNq6qbDUhXe1DcilbwRfasT6SeM+A01S2GvhnMwZPy0q2XAEi3VrS
 on7qdqt9F4rOTBVXVD6HJR59E+xX9K1FwUn6BgJLJCRAPyzLSdRDhskARkb8NMgafEY0
 kKexr29grj3zfRPrnHJopBBC/FRoT01MlFrvmv9mYW9Ol5YNfKFNnv8LQ6cJ0RJNxlel Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 300urk3hpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 01:07:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R17sQF156448;
        Fri, 27 Mar 2020 01:07:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3006r9ebjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 01:07:58 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02R17vj4017510;
        Fri, 27 Mar 2020 01:07:57 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 18:07:57 -0700
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: Remove non functional code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200206135443.110701-1-dwagner@suse.de>
Date:   Thu, 26 Mar 2020 21:07:55 -0400
In-Reply-To: <20200206135443.110701-1-dwagner@suse.de> (Daniel Wagner's
        message of "Thu, 6 Feb 2020 14:54:43 +0100")
Message-ID: <yq1o8sifvv8.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=960 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270007
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Daniel,

> Remove code which has no functional use anymore since 3c75ad1d87c7
> ("scsi: qla2xxx: Remove defer flag to indicate immeadiate port loss").

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
