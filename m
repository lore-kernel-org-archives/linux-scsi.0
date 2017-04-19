From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 8/8] scsi: Implement blk_mq_ops.show_rq()
Date: Wed, 19 Apr 2017 23:29:55 +0000
Message-ID: <1492644594.2543.20.camel@sandisk.com>
References: <20170418232949.5228-1-bart.vanassche@sandisk.com>
         <20170418232949.5228-9-bart.vanassche@sandisk.com>
         <yq1efworndq.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27848 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964869AbdDSXaA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 19:30:00 -0400
In-Reply-To: <yq1efworndq.fsf@oracle.com>
Content-Language: en-US
Content-ID: <6B8BC95D1CAEF149951D15773B400001@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "hare@suse.com" <hare@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>

On Wed, 2017-04-19 at 19:25 -0400, Martin K. Petersen wrote:
> Bart Van Assche <bart.vanassche@sandisk.com> writes:
> > Show the SCSI CDB, .eh_eflags and .result for pending SCSI commands
> > in /sys/kernel/debug/block/*/mq/*/dispatch and */rq_list.
>=20
> SCSI_EH_CANCEL_CMD is no more (as of a06586325f37).

Thanks Martin. I will remove that flag when I repost this patch series.

Bart.=
