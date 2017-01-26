From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 03/18] block: fix elevator init check
Date: Thu, 26 Jan 2017 23:21:49 +0000
Message-ID: <1485472889.2540.22.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
         <1485365126-23210-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0061.outbound.protection.outlook.com ([104.47.41.61]:45616
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753717AbdAZXWM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 18:22:12 -0500
In-Reply-To: <1485365126-23210-4-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <E942ED0E2F90874694FE60D9327D9C48@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>

On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
> We can't initalize the elevator fields for flushes as flush share space
> in struct request with the elevator data.  But currently we can't
> commnicate that a request is a flush through blk_get_request as we
> can only pass READ or WRITE, and the low-level code looks at the
> possible NULL bio to check for a flush.
>=20
> Fix this by allowing to pass any block op and flags, and by checking for
> the flush flags in __get_request.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
