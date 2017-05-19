From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 19/25] qla2xxx: Replace ql2xexchoffld & ql_dm_tgt_ex_pct
 parameter
Date: Fri, 19 May 2017 23:27:23 +0000
Message-ID: <1495236443.2581.17.camel@sandisk.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
         <20170519215344.2168-20-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48384 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755610AbdESX11 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 19:27:27 -0400
In-Reply-To: <20170519215344.2168-20-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <857ADE623455794DA5D8D4C54593E48C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-05-19 at 14:53 -0700, Himanshu Madhani wrote:
> [ ... ]
> -int ql2xexchoffld =3D 0;
> -module_param(ql2xexchoffld, uint, S_IRUGO|S_IWUSR);
> -MODULE_PARM_DESC(ql2xexchoffld,
> -		 "Number of exchanges to offload. "
> -		 "0 (Default)- Disabled.");
> +int ql2xtgtexchg =3D 1024;
> +module_param(ql2xtgtexchg, uint, 0644);
> +MODULE_PARM_DESC(ql2xtgtexchg,
> +	"Number of target exchanges.");
> +
> +int ql2xiniexchg =3D 1024;
> +module_param(ql2xiniexchg, uint, 0644);
> +MODULE_PARM_DESC(ql2xtgtexchg,
> +	"Number of initiator exchanges.");
> =20

[ ... ]
=20
> -static int ql_dm_tgt_ex_pct =3D 50;
> -module_param(ql_dm_tgt_ex_pct, int, S_IRUGO|S_IWUSR);
> -MODULE_PARM_DESC(ql_dm_tgt_ex_pct,
> -	"For Dual Mode (qlini_mode=3Ddual), this parameter determines "
> -	"the percentage of exchanges/cmds FW will allocate resources "
> -	"for Target mode.");
> -

Hello Himanshu and Quinn,

Renaming internal variables is fine but renaming module parameters is not
acceptable. Please don't do this.

Thanks,

Bart.=
