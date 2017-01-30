From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] storvsc: remove bogus code to transfer struct
 scatterlist
Date: Mon, 30 Jan 2017 17:19:02 +0000
Message-ID: <1485796728.2669.2.camel@sandisk.com>
References: <1485681138-21236-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0054.outbound.protection.outlook.com ([104.47.41.54]:38496
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750961AbdA3RTt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 12:19:49 -0500
In-Reply-To: <1485681138-21236-1-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <910EBC10633E7946AA61AA1E363FE01B@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "sthemmin@microsoft.com" <sthemmin@microsoft.com>, "haiyangz@microsoft.com" <haiyangz@microsoft.com>, "kys@microsoft.com" <kys@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, 2017-01-29 at 10:12 +0100, Christoph Hellwig wrote:
> Remove a piece of code in storvsc_queuecommand that tries to pass the
> physical address of the kernel struct scatterlist pointer to the host.
>=20
> Fortunately the code can't ever be reached anyway.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
