From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv2 3/5] scsi_error: do not escalate failed EH command
Date: Mon, 27 Feb 2017 22:21:29 +0000
Message-ID: <1488234046.2597.6.camel@sandisk.com>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
         <1487779650-1338-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:3744 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdB0Wur (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 17:50:47 -0500
In-Reply-To: <1487779650-1338-4-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <3DC42D9A65773542860A03F3F9FCA9F1@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>

On Wed, 2017-02-22 at 17:07 +0100, Hannes Reinecke wrote:
> When a command is sent as part of the error handling there
> is not point whatsoever to start EH escalation when that
> command fails; we are _already_ in the error handler,
> and the escalation is about to commence anyway.
> So just call 'scsi_try_to_abort_cmd()' to abort outstanding
> commands and let the main EH routine handle the rest.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
