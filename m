From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv3 3/6] scsi: make eh_eflags persistent
Date: Wed, 1 Mar 2017 23:29:55 +0000
Message-ID: <1488410983.2699.15.camel@sandisk.com>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
         <1488359720-130871-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:30844 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753739AbdCAXaZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 18:30:25 -0500
In-Reply-To: <1488359720-130871-4-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <AA33FF82E67DD84CB0A5FF77DEF585A0@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2017-03-01 at 10:15 +0100, Hannes Reinecke wrote:
> To detect if a failed command has been retried we must not
> clear scmd->eh_eflags when EH finishes.
> The flag should be persistent throughout the lifetime
> of the command.
>=20
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
