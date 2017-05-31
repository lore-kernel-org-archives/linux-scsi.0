From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 05/17] qla2xxx: Fix path recovery
Date: Wed, 31 May 2017 23:44:35 +0000
Message-ID: <1496274274.2608.34.camel@sandisk.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
         <20170530175432.26984-6-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:18395 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdEaXoh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 19:44:37 -0400
In-Reply-To: <20170530175432.26984-6-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <CB8251752C676C4DB92F8F5E3B47D358@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-05-30 at 10:54 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
>=20
> If the port is moved/changed, current code would trigger
> a deletion. If the port is already deleted, then do relogin.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
