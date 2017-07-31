From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 02/14] blk-mq: rename flush_busy_ctx_data as ctx_iter_data
Date: Mon, 31 Jul 2017 23:03:04 +0000
Message-ID: <1501542184.2466.24.camel@wdc.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
         <20170731165111.11536-4-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:32970 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751217AbdGaXDw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2017 19:03:52 -0400
In-Reply-To: <20170731165111.11536-4-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <1B6E01DCE4863743A0986A5FEF8490AD@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Tue, 2017-08-01 at 00:50 +0800, Ming Lei wrote:
> The following patch need to reuse this data structure,
> so rename as one generic name.

Hello Ming,

Please drop this patch (see also my comments on the next patch).

Thanks,

Bart.=
