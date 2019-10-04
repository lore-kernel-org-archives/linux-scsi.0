Return-Path: <SRS0=tG2Y=X5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD373C10F14
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 01:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 819ED20862
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 01:59:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JpyhKh2G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbfJDB7a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Oct 2019 21:59:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730604AbfJDB7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2019 21:59:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x941shQE046513;
        Fri, 4 Oct 2019 01:59:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=ByYDsQgoezJ1J5p6lCbNtJwzOqVloIQurniz2xQ2hpo=;
 b=JpyhKh2GWurJO8Pn93BnZqwrpUcGfJ7k0SGgkmW4OG/wVYCoyLTEMw/jwKjRyaN3eBDs
 Xns4j6Z020bW6YdbNRePYZi82gJ8BOpvbXk3tu+TgKowyap805xXzk8DPUFEvYqyXVPI
 EtDddI+V9HUTdXJnV2Vly7gXBfsg4PIdU2XZz4muiU3KgCLaCRQiIER98ET6ddbmxPtc
 gvn2XkMLB3DLIdA4uf+DwQtW8gZ+UGqaKFm/cllbd7iOcNhU6YSoB7NY4edEq+uSxxfb
 1L4Z1RIZLiOnEDbAUajmj8Al7gXsvT+7bW5UxiGWWy743EIwcEPT9DchpDyxgm2sqty9 Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2va05s82vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 01:59:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x941x4gO089413;
        Fri, 4 Oct 2019 01:59:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vdk0tbwd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 01:59:25 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x941xObn015567;
        Fri, 4 Oct 2019 01:59:24 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 18:59:24 -0700
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ch: add include guard to chio.h
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190728164643.16335-1-yamada.masahiro@socionext.com>
        <CAK7LNATbahbn4W_71F8dZynXNb7Kbr5ZHb7mTV2_4oZok5AK=w@mail.gmail.com>
Date:   Thu, 03 Oct 2019 21:59:22 -0400
In-Reply-To: <CAK7LNATbahbn4W_71F8dZynXNb7Kbr5ZHb7mTV2_4oZok5AK=w@mail.gmail.com>
        (Masahiro Yamada's message of "Thu, 3 Oct 2019 11:30:33 +0900")
Message-ID: <yq18sq1s22t.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=927
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Masahiro,

>> Add a header include guard just in case.

Fine with me. Is it going through your tree or should I pick it up?

-- 
Martin K. Petersen	Oracle Linux Engineering
