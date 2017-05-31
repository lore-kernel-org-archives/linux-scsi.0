From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 02/17] qla2xxx: Replace usage of spin_lock with
 spin_lock_irqsave
Date: Wed, 31 May 2017 23:43:37 +0000
Message-ID: <1496274216.2608.32.camel@sandisk.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
         <20170530175432.26984-3-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:47395 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdEaXnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 19:43:40 -0400
In-Reply-To: <20170530175432.26984-3-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <D4AEBC1E5A42914F9DDF50CB2FC08B2D@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-05-30 at 10:54 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
>=20
> Convert usage of spin_lock to spin_lock_irqsave because qla2xxx driver
> accesses all the data structures in an interrupt context.

Did you perhaps mean "*can* access all data structures in interrupt context=
"?

Anyway:

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
