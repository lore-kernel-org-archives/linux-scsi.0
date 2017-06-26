From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Mon, 26 Jun 2017 12:13:41 +0000
Message-ID: <1498479220.8799.0.camel@wdc.com>
References: <20170616082755.22832-1-hch@lst.de>
         <1498143933.6002.18.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:31160 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752139AbdFZMNt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 08:13:49 -0400
In-Reply-To: <1498143933.6002.18.camel@suse.com>
Content-Language: en-US
Content-ID: <2E5774F34D17104BB669C7CAB9F6F65C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mwilck@suse.com" <mwilck@suse.com>

On Thu, 2017-06-22 at 17:05 +0200, Martin Wilck wrote:
> On Fri, 2017-06-16 at 10:27 +0200, Christoph Hellwig wrote:
> > Remove the SCSI_MQ_DEFAULT config option and default to the blk-mq
> > I/O
> > path now that we had plenty of testing, and have I/O schedulers for
> > blk-mq.  The module option to disable the blk-mq path is kept around
> > for now.
>=20
> Could you explain why you remove the option entirely rather than just
> changing the default? Some distributions may wish to keep the ability
> to choose the compiled-in default.

Hello Martin,

Would it work for you to keep this patch as a distro-private patch?

Bart.=
