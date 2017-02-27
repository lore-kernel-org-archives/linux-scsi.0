From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv2 2/5] scsi: make eh_eflags persistent
Date: Mon, 27 Feb 2017 22:15:26 +0000
Message-ID: <1488233711.2597.5.camel@sandisk.com>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
         <1487779650-1338-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:48919 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751891AbdB0WV7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 17:21:59 -0500
In-Reply-To: <1487779650-1338-3-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <F87C8461585E204684A69AB81409B490@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>

On Wed, 2017-02-22 at 17:07 +0100, Hannes Reinecke wrote:
> To detect if a failed command has been retried we must not
> clear scmd->eh_eflags when EH finishes.
> The flag should be persistent throughout the lifetime
> of the command.

Hello Hannes,

Is it on purpose that this patch does not remove the following statement fr=
om
drivers/scsi/libsas/sas_scsi_host.c?

		cmd->eh_eflags =3D 0;

Thanks,

Bart.=
