From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 6/9] scsi: Improve scsi_get_sense_info_fld
Date: Fri, 21 Apr 2017 16:58:43 +0000
Message-ID: <1492793923.2550.9.camel@sandisk.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
         <20170421091649.25287-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:54749 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162106AbdDURBs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 13:01:48 -0400
In-Reply-To: <20170421091649.25287-7-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <1E4A7363C738254F805895B54022E768@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
> @@ -2363,42 +2365,32 @@ EXPORT_SYMBOL(scsi_command_normalize_sense);
>   * Return value:
>   *	1 if information field found, 0 if not found.
>   */
> -int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
> -			    u64 * info_out)
> +bool scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
> +			     u64 * info_out)

Hello Damien,

If you have to repost this patch please address the checkpatch complaints
of the following category triggered by the above declaration:

ERROR: "foo * bar" should be "foo *bar"

Otherwise this patch looks fine to me. Hence:

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
