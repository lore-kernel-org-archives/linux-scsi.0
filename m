From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 01/17] qla2xxx: Allow ABTS RX, RIDA on ATIOQ for
 ISP83XX/27XX
Date: Wed, 31 May 2017 23:42:47 +0000
Message-ID: <1496274166.2608.31.camel@sandisk.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
         <20170530175432.26984-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:27001 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdEaXmu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 19:42:50 -0400
In-Reply-To: <20170530175432.26984-2-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <EC15FBAD7CD01D4FA317FE40697AF9B0@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-05-30 at 10:54 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
>=20
> Driver added mechanism to move ABTS/PUREX/RIDA mailbox to
> ATIO queue as part of commit id 41dc529a4602ac737020f423f84686a81de38e6d
> ("qla2xxx: Improve RSCN handling in driver").
>=20
> This patch addes a check to only allow ABTS/PURX/RIDA
> to be moved to ATIO Queue for ISP83XX and ISP27XX.

Did you perhaps mean "adds" instead of "adds"? Anyway:

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
