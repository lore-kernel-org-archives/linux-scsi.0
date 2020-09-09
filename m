Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 462B5C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E1B0206A5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zJvD51Sp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgIICF2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:05:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53456 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIICF1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:05:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0891xjOr123849;
        Wed, 9 Sep 2020 02:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tFOAzv9XG0TyeHmRnwIuZNeJgtdSDcUleU6XmnRHAL8=;
 b=zJvD51SpeAni12qAtPF8lK8ydY5jD/T8+3S8AJXZrQQqGySEyMMJc94Jxdkd7VBqe5Gi
 fx5jUjApbeO51G7EvW12FGpcC6hrV5zVPoQF6HEj1xMDc67e8jU8ni02imy2MHE43xwf
 kDDyAD+/V/IF73mA0ayx69zjWjjYk4WuVVRh7uZQ/PVGLE5WS0COn+pqw3hsao1ttqXD
 suGK57s6y8rI9Z5SwytXIhxhk4J4/GXBVQp7lBAp6jR0mIS0oHlv8CwKFhwTqRPUSeW5
 v0ZezsOBztgFCA32isTghzRzRKsjD8NzBiR5p3sjfHd0Nz3jbMwhE7t0ODFV+Hn/DkzT YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 33c23qxyy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:05:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08920Llu172600;
        Wed, 9 Sep 2020 02:05:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33cmkwwb5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:05:07 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 089254MK006328;
        Wed, 9 Sep 2020 02:05:04 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:05:03 -0700
To:     "=?utf-8?Q?N=C3=ADcolas?= F. R. A. Prado" <nfraprado@protonmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-scsi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        lkcamp@lists.libreplanetbr.org, andrealmeid@collabora.com
Subject: Re: [PATCH] scsi: docs: Remove obsolete scsi typedef text from
 scsi_mid_low_api
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14ko766yx.fsf@ca-mkp.ca.oracle.com>
References: <20200905210211.2286172-1-nfraprado@protonmail.com>
Date:   Tue, 08 Sep 2020 22:05:01 -0400
In-Reply-To: <20200905210211.2286172-1-nfraprado@protonmail.com>
 (=?utf-8?Q?=22N=C3=ADcolas?=
        F. R. A. Prado"'s message of "Sat, 05 Sep 2020 21:03:00 +0000")
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=1 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


N=C3=ADcolas,

> Commit 91ebc1facd77 ("scsi: core: remove Scsi_Cmnd typedef") removed
> the Scsi_cmnd typedef but it was still mentioned in a paragraph in the
> "SCSI mid_level - lower_level driver interface" documentation page.
> Remove this obsolete paragraph.

Applied to my 5.10 staging tree. Thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering
