From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 35/35] scsi: Do not allocate scsi command in
 scsi_ioctl_reset()
Date: Fri, 23 Jun 2017 17:49:33 +0000
Message-ID: <1498240171.2735.11.camel@wdc.com>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
         <1498222975-71858-36-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:25150 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754601AbdFWRtf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2017 13:49:35 -0400
In-Reply-To: <1498222975-71858-36-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <8DC35FC700351946B585A8759699A85B@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On Fri, 2017-06-23 at 15:02 +0200, Hannes Reinecke wrote:
> As we now have moved the error handler functions to not rely on
> a scsi command we can drop the out-of-band scsi command allocation
> from scsi_ioctl_reset().

I'm glad that that command allocation is gone :-)

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>=
