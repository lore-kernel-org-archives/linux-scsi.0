Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AD6CA9EB3
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 02:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16E4C21D7C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 02:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oCuQYW6M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438932AbfJRCCM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 22:02:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57556 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407087AbfJRCCM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2019 22:02:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I1wdGo107145;
        Fri, 18 Oct 2019 02:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=rJErIrykXy1XP9fZ/qdZ1PNvEAo+sxRibSivKgwTD9k=;
 b=oCuQYW6MluBLuLYGO29BebJ9pPYFB/lk/b3lcn64arTUE3YzUDlk79gRit66E4qv4oLa
 0EbKtYG5CKU1yaUx4LJSzNrh8HOsNGBcuCH8pFYfHT9rz8fS9Z/xMVT5NYE1l4mn67YS
 JMXwvsHQciAW99Q/lqruQjnHhNHPVV7S2QIxqoVT//k8+5C/ofxl62597aaMCRPnYEPu
 R2jvkvkBJ6cFTMm8Ft67XMg69VaqHt8eIeuk+/9snX21WfqO0TSdNLXdJ64QmUPgNQcW
 eKf16/lGWPs/EVPsO+hG062jrW1y1SFlH2LbohJQ1N3uZViA7Moo/XjT29sC9iiFqsVI 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vq0q40r3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 02:02:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9I1vfOx179682;
        Fri, 18 Oct 2019 02:02:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vq0dwc2ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 02:01:59 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9I21tG7006865;
        Fri, 18 Oct 2019 02:01:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 02:01:55 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Martin George <martin.george@netapp.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] lpfc: remove left-over BUILD_NVME defines
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191017150019.75769-1-hare@suse.de>
Date:   Thu, 17 Oct 2019 22:01:52 -0400
In-Reply-To: <20191017150019.75769-1-hare@suse.de> (Hannes Reinecke's message
        of "Thu, 17 Oct 2019 17:00:19 +0200")
Message-ID: <yq1eezake0f.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=810
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=896 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> The BUILD_NVME define never got defined anywhere, causing NVMe
> commands to be treated as SCSI commands when freeing the buffers.
> This was causing a stuck discovery and a horrible crash in
> lpfc_set_rrq_active() later on.

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
