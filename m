From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/3] scsi_dh_alua: Do not modify the interval value for
 retries
Date: Fri, 28 Apr 2017 18:35:01 +0000
Message-ID: <1493404499.2767.13.camel@sandisk.com>
References: <20170428130626.32162-1-mwilck@suse.com>
         <20170428130626.32162-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26980 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164374AbdD1SfE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2017 14:35:04 -0400
In-Reply-To: <20170428130626.32162-2-mwilck@suse.com>
Content-Language: en-US
Content-ID: <0551D34C81B297458240B5E6E23E2CA4@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-04-28 at 15:06 +0200, Martin Wilck wrote:
> @@ -886,7 +883,7 @@ static bool alua_rtpg_queue(struct alua_port_group *p=
g,
>  		force =3D true;
>  	}
>  	if (pg->rtpg_sdev =3D=3D NULL) {
> -		pg->interval =3D 0;
> +		pg->interval =3D 2;
>  		pg->flags |=3D ALUA_PG_RUN_RTPG;
>  		kref_get(&pg->kref);
>  		pg->rtpg_sdev =3D sdev;

Hello Hannes and Martin,

Why is .interval initialized in alua_rtpg_queue() instead of in
alua_alloc_pg()? I think initializing it in alua_alloc_pg() would
make more clear that .interval is constant.

Thanks,

Bart.=
