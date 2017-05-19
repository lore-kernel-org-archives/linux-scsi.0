From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] Use ctlr directly in rdac_failover_get()
Date: Fri, 19 May 2017 22:23:30 +0000
Message-ID: <1495232608.2581.3.camel@sandisk.com>
References: <1495195574-27835-1-git-send-email-asavkov@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:31210 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756707AbdESWXe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 18:23:34 -0400
In-Reply-To: <1495195574-27835-1-git-send-email-asavkov@redhat.com>
Content-Language: en-US
Content-ID: <C2FE21B025018F4D988537242297AD30@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "asavkov@redhat.com" <asavkov@redhat.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Fri, 2017-05-19 at 14:06 +0200, Artem Savkov wrote:
> rdac_failover_get references struct rdac_controller as
> ctlr->ms_sdev->handler_data->ctlr for no apparent reason. Besides being
> inefficient this also introduces a null-pointer dereference as
> send_mode_select() sets ctlr->ms_sdev to NULL before calling
> rdac_failover_get():
>=20
> [ ... ]
> Signed-off-by: Artem Savkov <asavkov@redhat.com>

Hello Artem,

Although this patch looks fine to me, please consider adding the "Fixes:" a=
nd
"Cc: <stable@vger.kernel.org>" tags.

Bart.=
