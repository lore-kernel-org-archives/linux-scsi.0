From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 20/25] qla2xxx: Remove redundant code
Date: Wed, 31 May 2017 23:41:28 +0000
Message-ID: <1496274086.2608.30.camel@sandisk.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
         <20170519215344.2168-21-himanshu.madhani@cavium.com>
         <1495237379.2581.19.camel@sandisk.com>
         <1495427279.27407.20.camel@haakon3.risingtidesystems.com>
         <1495477383.1017.3.camel@sandisk.com>
         <71DF2234-3414-4AD7-AE31-E974F92E4708@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:10015 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdEaXla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 19:41:30 -0400
In-Reply-To: <71DF2234-3414-4AD7-AE31-E974F92E4708@cavium.com>
Content-Language: en-US
Content-ID: <512E433F0118EC4DB8FC6540D1012766@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Quinn.Tran@cavium.com" <Quinn.Tran@cavium.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Himanshu.Madhani@cavium.com" <Himanshu.Madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Mon, 2017-05-22 at 22:14 +0000, Tran, Quinn wrote:
>=20
> I think an initiator could get
>     really confused if it receives two responses for the same exchange.
>=20
> QT:  I do see the window you=A2re describing in the qlt_try_to_dequeue_un=
known_atios().
> Will have to follow up with another patch.   This patch is not meant for =
this window
> you=A2ve just identify.

Hello Quinn,

Has that patch been included in v2 of this series or will that patch perhap=
s be
made available later?

Thanks,

Bart.=
