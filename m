Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565F4C2BD09
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 04:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21E742077B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 04:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I2EwFONY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfLKEJB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 23:09:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbfLKEJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 23:09:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBB442Pp179945;
        Wed, 11 Dec 2019 04:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=NsytSED1IdKLk5zj6xtHrR0U2YjxCSjKc6zTpdZVg4Q=;
 b=I2EwFONYap60CNgUAo3T/+I6fxoUgXpkeedOuHbGWnRe5I51yYyxDxB8z3fhUhTIdVGq
 ZPQ20I86VGh4Ks5AIiQkfmCZSiUm2M+rVhq8A5eMzeo92Hc5GvFOWSxTQKjS1masJky8
 BF1Khtt7o1kq+eQH6iBB/6ZxQBxkmaKv+727ppF+maxHdFucRZRQCN2u/5bou3oCcpJg
 ioYfSZgw5GArinBEWHxPE3bCgu/+01fPXDzZra81hUuj2utqRw1m2IA4Uu5IXTpDfOV1
 x7GuNkXCLQ1HudrnJb0A0U7kyq/qwGyE6TVil26Fp7vvoMABI6Ogw9yBwiCuLiRgrghy sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wrw4n6x8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 04:08:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBB4462h010025;
        Wed, 11 Dec 2019 04:08:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wte9b9sm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 04:08:36 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBB48YKM022438;
        Wed, 11 Dec 2019 04:08:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Dec 2019 20:08:07 -0800
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/1] Summary: hwmon driver for temperature sensors on SATA drives
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191209052119.32072-1-linux@roeck-us.net>
Date:   Tue, 10 Dec 2019 23:08:04 -0500
In-Reply-To: <20191209052119.32072-1-linux@roeck-us.net> (Guenter Roeck's
        message of "Sun, 8 Dec 2019 21:21:18 -0800")
Message-ID: <yq15zinmrmj.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912110034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912110034
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Guenter,

> The most recent attempt was [1] by Linus Walleij. It went through a total
> of seven iterations. At the end, it was rejected for a number of reasons;
> see the provided link for details. This implementation resides in the
> SCSI core. It originally resided in libata but was moved to SCSI per
> maintainer request, where it was ultimately rejected.

While I am sure I come across as a curmudgeon, regressions is a major
concern for me. That, and making sure we pick the right architecture. I
thought we were making good progress in that department when Linus
abandoned the effort.

> The feedback on this approach suggests to use the SCSI Temperature log
> page [0x0d] as means to access drive temperature information. It is
> unknown if this is implemented in any real SCSI drive.

Almost every SCSI drive has it.

> The feedback also suggests to obtain temperature from ATA drives,
> convert it into the SCSI temperature log page in libata-scsi, and to
> use that information in a hardware monitoring driver. The format and
> method to do this is documented in [3]. This is not currently
> implemented in the Linux kernel.

Correct, but I have no qualms over exporting the SCSI temperature log
page. The devices that export that page are generally well-behaved.

My concerns are wrt. identifying whether SMART data is available for
USB/UAS. I am not too worried about ATA and "real" SCSI (ignoring RAID
controllers that hide the real drives in various ways).

I am not sure why the SCSI temperature log page parsing would be
complex. I will have to go check smartmontools to see what that is all
about. The spec is as simple as can be.

Anyway. I think the overall approach wrt. SCT and falling back to
well-known SMART fields is reasonably sane and fine for libata. But I
don't understand the pushback wrt. using the SCSI temperature log page
as a conduit. I think it would be fine if this worked out of the box for
both SCSI and ATA drives.

The elephant in the room remains USB. And coming up with a way we can
reliably detect whether it is safe to start poking at the device to
discover if SMART is provided. If we eventually want to pursue USB, I
think your heuristic stuff needs to be a library that can be leveraged
by both libata and USB. But that doesn't have to be part of the initial
effort.

And finally, my concerns wrt. reacting to bad sensors remain. Not too
familiar with hwmon, but I would still like any actions based on
reported temperatures to be under user control and not the kernel.

-- 
Martin K. Petersen	Oracle Linux Engineering
