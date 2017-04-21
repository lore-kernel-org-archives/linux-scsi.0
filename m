From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 7/9] sd_zbc: Rename sd_zbc_setup_write_cmnd
Date: Fri, 21 Apr 2017 17:07:16 +0000
Message-ID: <1492794436.2550.13.camel@sandisk.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
         <20170421091649.25287-8-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:52385 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162294AbdDURHj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 13:07:39 -0400
In-Reply-To: <20170421091649.25287-8-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <AE31972A8CF08340AD1C769DDD59833A@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
> Rename sd_zbc_setup_write_cmnd() to sd_zbc_write_lock_zone() to be
> clear about what the function actually does. To be consistent, also
> rename sd_zbc_cancel_write_cmnd() to sd_zbc_write_unlock_zone().
>=20
> [ ... ]
>  	/*
> -	 * resid is optional but mostly filled in.  When it's unused,
> +	 * resid is optional but mostly filled in. When it's unused,
>  	 * its value is zero, so we assume the whole buffer transferred
>  	 */

Is this whitespace-only change useful? Otherwise this patch looks fine
to me. Hence:

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
