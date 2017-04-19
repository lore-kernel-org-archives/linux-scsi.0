From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 01/23] pd: don't check blk_execute_rq return value.
Date: Wed, 19 Apr 2017 21:02:33 +0000
Message-ID: <1492635752.2543.16.camel@sandisk.com>
References: <20170419192708.22098-1-hch@lst.de>
         <20170419192708.22098-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45612 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966202AbdDSVCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 17:02:37 -0400
In-Reply-To: <20170419192708.22098-2-hch@lst.de>
Content-Language: en-US
Content-ID: <3FAF775C736EE541AE35AC0A409F319E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Wed, 2017-04-19 at 21:26 +0200, Christoph Hellwig wrote:
> The driver never sets req->errors, so blk_execute_rq will always return 0=
.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
