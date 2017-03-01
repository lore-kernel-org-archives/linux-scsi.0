From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] mpt3sas: Avoid sleeping in interrupt context
Date: Wed, 1 Mar 2017 17:09:48 +0000
Message-ID: <1488388175.2699.7.camel@sandisk.com>
References: <20170301170036.11540-1-bart.vanassche@sandisk.com>
         <20170301170458.GA3486@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:14493 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbdCARRm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 12:17:42 -0500
In-Reply-To: <20170301170458.GA3486@vader.DHCP.thefacebook.com>
Content-Language: en-US
Content-ID: <EA49D65C9D9CE247B017293D1B713143@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "osandov@osandov.com" <osandov@osandov.com>
Cc: "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Sreekanth.Reddy@broadcom.com" <Sreekanth.Reddy@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>

On Wed, 2017-03-01 at 09:04 -0800, Omar Sandoval wrote:
> Thanks, Bart, you can add
>=20
> Tested-by: Omar Sandoval <osandov@fb.com>

Hello Omar,

Have you been able to test both code paths - scsi-mq enabled and scsi-mq
disabled?

Thanks,

Bart.=
