From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4 10/10] scsi: Implement blk_mq_ops.show_rq()
Date: Mon, 24 Apr 2017 21:49:37 +0000
Message-ID: <1493070575.3394.19.camel@sandisk.com>
References: <20170421234026.18970-1-bart.vanassche@sandisk.com>
         <20170421234026.18970-11-bart.vanassche@sandisk.com>
         <yq1k269ij5f.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44304 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S977306AbdDXVtl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 17:49:41 -0400
In-Reply-To: <yq1k269ij5f.fsf@oracle.com>
Content-Language: en-US
Content-ID: <198A5D4B76F65F4D82B302DD734D912B@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "hare@suse.com" <hare@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>

On Mon, 2017-04-24 at 17:35 -0400, Martin K. Petersen wrote:
> > Show the SCSI CDB, .eh_eflags and .result for pending SCSI commands
> > in /sys/kernel/debug/block/*/mq/*/dispatch and */rq_list.
>=20
> Why not use SCSI tracing if you are interested in these?

Hello Martin,

SCSI tracing has to be enabled before a test is started, produces a huge am=
ount
of data, and deriving state information from a huge trace is far from easy.=
 The
information in debugfs provides an easy to read overview of the current sta=
te
without having to analyze megabytes of traces, without introducing any slow=
down
and without having to enable any tracing mechanism from beforehand.

Bart.=
