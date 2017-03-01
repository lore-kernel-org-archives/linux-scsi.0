From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv3 5/6] scsi: make scsi_eh_scmd_add() always succeed
Date: Wed, 1 Mar 2017 23:34:25 +0000
Message-ID: <1488411244.2699.16.camel@sandisk.com>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
         <1488359720-130871-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:65385 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752979AbdCAXqy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 18:46:54 -0500
In-Reply-To: <1488359720-130871-6-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <C3D86920EDD5D745B8B588544E5C6897@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2017-03-01 at 10:15 +0100, Hannes Reinecke wrote:
> scsi_eh_scmd_add() currently only will fail if no
> error handler thread is started (which will never be the
> case) or if the state machine encounters an illegal transition.
>=20
> But if we're encountering an invalid state transition
> chances is we cannot fixup things with the error handler.
> So better add a WARN_ON for illegal host states and
> make scsi_dh_scmd_add() a void function.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
