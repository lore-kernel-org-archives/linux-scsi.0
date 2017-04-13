From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 01/25] remove the mg_disk driver
Date: Thu, 13 Apr 2017 19:58:13 +0000
Message-ID: <1492113491.24345.7.camel@sandisk.com>
References: <20170406153944.10058-1-hch@lst.de>
         <20170406153944.10058-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:27778 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932118AbdDMT6R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2017 15:58:17 -0400
In-Reply-To: <20170406153944.10058-2-hch@lst.de>
Content-Language: en-US
Content-ID: <9B2C9CCD2A4A4845A8D68E17CFD12059@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Thu, 2017-04-06 at 17:39 +0200, Christoph Hellwig wrote:
> This drivers was added in 2008, but as far as a I can tell we never had a
> single platform that actually registered resources for the platform drive=
r.
>=20
> It's also been unmaintained for a long time and apparently has a ATA mode
> that can be driven using the IDE/libata subsystem.

Hello Christoph,

Should the person who submitted this driver be CC-ed for this patch (unsik
Kim <donari75@gmail.com>)?

Bart.=
