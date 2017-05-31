From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 11/17] qla2xxx: Turn on FW option for exchange check
Date: Wed, 31 May 2017 23:52:01 +0000
Message-ID: <1496274720.2608.38.camel@sandisk.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
         <20170530175432.26984-12-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:7646 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdEaXwD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 19:52:03 -0400
In-Reply-To: <20170530175432.26984-12-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <171DD9A53DB72947A753552DF7BFC6D8@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-05-30 at 10:54 -0700, Himanshu Madhani wrote:
> -	ctio->u.status1.flags =3D (atio->u.isp24.attr << 9) |
> -	    cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS);
> +	temp =3D (atio->u.isp24.attr << 9)|
> +		CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS;
> +	ctio->u.status1.flags =3D cpu_to_le16(temp);

This patch not only includes the functional changes explained in the patch
description but also several changes that do not change any functionality
like the above. Please keep functional and non-functional changes separate
for future patch submissions.

Thanks,

Bart.=
