From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 04/25] qla2xxx: Replace usage of spin_lock with
 spin_lock_irqsave
Date: Fri, 19 May 2017 22:50:39 +0000
Message-ID: <1495234238.2581.10.camel@sandisk.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
         <20170519215344.2168-5-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19831 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754196AbdESWum (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 18:50:42 -0400
In-Reply-To: <20170519215344.2168-5-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <EC16DE96DE8B9C40B4E4D2B84235E664@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-05-19 at 14:53 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
>=20
> qla2xxx driver lives in interrupt context. Remove
> spin_lock usage to prevent leaving CPU in a strange
> state.

Hello Himanshu and Quinn,

Did you perhaps mean that the command lists can be accessed from interrupt
context? If so, please mention this in the patch description.

Thanks,

Bart.=
