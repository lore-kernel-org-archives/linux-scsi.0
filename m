Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A21BC47404
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE5562086D
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:32:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Arf12o+5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732332AbfJJCcA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 22:32:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38234 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfJJCcA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 22:32:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2SdVW046703;
        Thu, 10 Oct 2019 02:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=lw4+BvVXBsmztDPGvNvebxLCtsQLgWw7jobp9fbwG6k=;
 b=Arf12o+5c9WSoTAcIrgz6LoUfxF7kvgA3oFQG3tnOVd/UGvAJ3WbeRQGLxzSm/sWdhv9
 MdgOBB1w574cyKzKynHkOu19PRuhK6zZgQx5UaHCT6MrjLJ2r9QFu2OXsDvftxOibiS9
 GyXGOax+3CrdJGYYpuouRGH6wYw0j6vmwrJxTHm3GRK9cJ+NpO34A8xLfN2LTiC8e4zr
 sDFbEZPC5Rpcb58oN/oTSSwZnCWSlmcLeaGv/gS58AQue0hLDR5+I0kJId7A8i7wwHOw
 mH9bi6XOa4NhA6wctyZN+goH3hFFW9ttDVOZkQXMX3Hq3J9N4qxfh7g+rz8F2LiVyjmr Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vek4qr702-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:31:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2RsR2035184;
        Thu, 10 Oct 2019 02:31:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vhrxcj6fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:31:54 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9A2VrMD024589;
        Thu, 10 Oct 2019 02:31:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 19:31:52 -0700
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ch: add include guard to chio.h
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190728164643.16335-1-yamada.masahiro@socionext.com>
        <CAK7LNATbahbn4W_71F8dZynXNb7Kbr5ZHb7mTV2_4oZok5AK=w@mail.gmail.com>
        <yq18sq1s22t.fsf@oracle.com>
        <CAK7LNAQ2gkWNgLfsdkFzo1_ySq=0JN616vfLpvBc38kezCz+YQ@mail.gmail.com>
Date:   Wed, 09 Oct 2019 22:31:50 -0400
In-Reply-To: <CAK7LNAQ2gkWNgLfsdkFzo1_ySq=0JN616vfLpvBc38kezCz+YQ@mail.gmail.com>
        (Masahiro Yamada's message of "Fri, 4 Oct 2019 11:20:38 +0900")
Message-ID: <yq1imoxjppl.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Masahiro,

>> Fine with me. Is it going through your tree or should I pick it up?
>
> Could you please apply it to your tree?

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
