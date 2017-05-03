From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] sd: Ignore sync cache failures when not supported
Date: Wed, 3 May 2017 18:23:50 +0000
Message-ID: <1493835829.3901.30.camel@sandisk.com>
References: <1489682932-18543-1-git-send-email-thierry.escande@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5323 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdECSXx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 14:23:53 -0400
In-Reply-To: <1489682932-18543-1-git-send-email-thierry.escande@collabora.com>
Content-Language: en-US
Content-ID: <748C042113BDE1409064D3F08D88E9DA@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "thierry.escande@collabora.com" <thierry.escande@collabora.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, 2017-03-16 at 17:48 +0100, Thierry Escande wrote:
> -static int sd_sync_cache(struct scsi_disk *sdkp)
> +static int sd_sync_cache(struct scsi_disk *sdkp, int *sense_key)
>  {
>  	int retries, res;
>  	struct scsi_device *sdp =3D sdkp->device;

Hello Thierry,

Both in the SCSI spec and in struct scsi_sense_hdr sense keys are declared
as eight bit values. So I would appreciate if the sense_key data type would
be changed from "int" into "u8". Otherwise this patch looks fine to me.

Thanks,

Bart.=
