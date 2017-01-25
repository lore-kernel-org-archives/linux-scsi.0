From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] SCSI core: Fix WRITE SAME handling
Date: Wed, 25 Jan 2017 22:44:41 +0000
Message-ID: <1485384261.2646.8.camel@sandisk.com>
References: <5bedd463-8f55-4506-0593-fd0040c47a17@sandisk.com>
         <20170125103725.GA18026@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0061.outbound.protection.outlook.com ([104.47.34.61]:47648
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752279AbdAYWou (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 17:44:50 -0500
In-Reply-To: <20170125103725.GA18026@lst.de>
Content-Language: en-US
Content-ID: <85FA234DA82C864EAC6984387914A898@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mchristi@redhat.com" <mchristi@redhat.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "sagi@grimberg.me" <sagi@grimberg.me>

On Wed, 2017-01-25 at 11:37 +0100, Christoph Hellwig wrote:
> > Fixes: f80de881d8df ("sd: remove __data_len hack for WRITE SAME")
>=20
> I think the better fix is to simply revert this commit.

Hello Christoph,

Do you mean reverting commit f80de881d8df only for kernel release v4.10
or also for future releases? How about resubmitting a reworked version of
commit f80de881d8df for kernel v4.11?

Thanks,

Bart.=
