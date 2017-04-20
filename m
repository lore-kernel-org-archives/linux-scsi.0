From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 02/23] block: remove the blk_execute_rq return value
Date: Thu, 20 Apr 2017 15:19:01 +0000
Message-ID: <1492701540.2642.0.camel@sandisk.com>
References: <20170420140316.6546-1-hch@lst.de>
         <20170420140316.6546-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:29752 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970355AbdDTPTM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 11:19:12 -0400
In-Reply-To: <20170420140316.6546-3-hch@lst.de>
Content-Language: en-US
Content-ID: <0F65F8FEA318F54E96F5FC32A69F6029@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Thu, 2017-04-20 at 16:02 +0200, Christoph Hellwig wrote:
> The function only returns -EIO if rq->errors is non-zero, which is not
> very useful and lets a large number of callers ignore the return value.
>=20
> Just let the callers figure out their error themselves.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
