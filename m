From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 5/9] sd: Cleanup sd_done sense data handling
Date: Fri, 21 Apr 2017 18:41:08 +0000
Message-ID: <1492800068.2550.25.camel@sandisk.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
         <20170421091649.25287-6-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:9196 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1041548AbdDUSlM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 14:41:12 -0400
In-Reply-To: <20170421091649.25287-6-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <CB02BFF1A2B8E440B8A1BC3406549109@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
> @@ -1884,8 +1886,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  				else {
>  					sdkp->device->no_write_same =3D 1;
>  					sd_config_write_same(sdkp);
> -
> -					good_bytes =3D 0;
>  					req->__data_len =3D blk_rq_bytes(req);
>  					req->rq_flags |=3D RQF_QUIET;
>  				}

This change looks fine to me but has not been described in the patch
description? Anyway:

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
