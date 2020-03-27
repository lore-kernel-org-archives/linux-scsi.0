Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53812C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 02:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 252252074D
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 02:52:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ib27WYBT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgC0CwI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 22:52:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53050 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbgC0CwI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 22:52:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2nMgH110834;
        Fri, 27 Mar 2020 02:51:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=tPE9Rk7po0wpOsJQMRQ8y8WoROd6iF7eSGz5aYp5ctk=;
 b=Ib27WYBTxsMJV+8Vdo8nWipr7kQ0e9vSydGsPmkDF3qPy6njJ5jwkj4AdC2bumlgpMAr
 NY15flIKZHNsFt5kBISE09ydpOOgEyJRTN+t/3Bkdxft8b0fczAUA6imzoxG8/h7FLTE
 Pd4hMRqLF+7YcQc+ulJBQxKgKzQ5A2AbdHY64bH9VcxT66i0g5QCFoqr0U4vYpIFWoHh
 ghasVMnUYHlA8wYErglvAf68RbWQGyHLIbUvHhjgtlLpudvYRdt1Cw1UjtrqcNKuY87X
 PZvtcTERSDyTTHvURSe0u5FfJYQhTCk6nWxZKzNTNUAfFm9PHZBYN5vyyOi1u3n5WjUd jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3014598r3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:51:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2ox1N162686;
        Fri, 27 Mar 2020 02:51:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30073f91qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:51:55 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02R2plY3031118;
        Fri, 27 Mar 2020 02:51:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 19:51:47 -0700
To:     Christoph Hellwig <hch@lst.de>
Cc:     oliver@neukum.org, aliakc@web.de, lenehan@twibble.org,
        dc395x@twibble.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] dc395x: remove dc395x_bios_param
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200325105505.1028582-1-hch@lst.de>
Date:   Thu, 26 Mar 2020 22:51:44 -0400
In-Reply-To: <20200325105505.1028582-1-hch@lst.de> (Christoph Hellwig's
        message of "Wed, 25 Mar 2020 11:55:05 +0100")
Message-ID: <yq1pncycxxb.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=900 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=977
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> dc395x_bios_param was only different from the default when the
> CONFIG_SCSI_DC395x_TRMS1040_TRADMAP symbol is true, but that symbol
> doesn't exist in the Kconfig system and thus can't be set.

Applied to 5.7/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
