From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Mon, 26 Jun 2017 15:31:20 +0000
Message-ID: <1498491078.8799.2.camel@wdc.com>
References: <20170616082755.22832-1-hch@lst.de>
         <1498143933.6002.18.camel@suse.com> <1498479220.8799.0.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11388 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFZPbW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 11:31:22 -0400
In-Reply-To: <1498479220.8799.0.camel@wdc.com>
Content-Language: en-US
Content-ID: <96A5B6B5A6E8794699E349CDAF12E1FD@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mwilck@suse.com" <mwilck@suse.com>

On Mon, 2017-06-26 at 12:13 +0000, Bart Van Assche wrote:
> On Thu, 2017-06-22 at 17:05 +0200, Martin Wilck wrote:
> > On Fri, 2017-06-16 at 10:27 +0200, Christoph Hellwig wrote:
> > > Remove the SCSI_MQ_DEFAULT config option and default to the blk-mq
> > > I/O
> > > path now that we had plenty of testing, and have I/O schedulers for
> > > blk-mq.  The module option to disable the blk-mq path is kept around
> > > for now.
> >=20
> > Could you explain why you remove the option entirely rather than just
> > changing the default? Some distributions may wish to keep the ability
> > to choose the compiled-in default.
>=20
> Hello Martin,
>=20
> Would it work for you to keep this patch as a distro-private patch?

What I meant is: apply this patch to the upstream kernel and keep=20
CONFIG_SCSI_MQ_DEFAULT as a distro-private patch.

Bart.=
