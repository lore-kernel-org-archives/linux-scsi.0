From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv2 5/5] scsi: make asynchronous aborts mandatory
Date: Mon, 27 Feb 2017 22:53:57 +0000
Message-ID: <1488236023.2597.10.camel@sandisk.com>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
         <1487779650-1338-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:7659 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbdB1BBU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 20:01:20 -0500
In-Reply-To: <1487779650-1338-6-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <5AE9271FA0E03C47927F857FCB794F70@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>

On Wed, 2017-02-22 at 17:07 +0100, Hannes Reinecke wrote:
> There hasn't been any reports for HBAs where asynchronous abort
> would not work, so we should make it mandatory and remove
> the fallback.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
