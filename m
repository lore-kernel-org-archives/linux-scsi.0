From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 12/15] qedf: Move some prints to a debug level so they do
 not print when no debugging is enabled.
Date: Wed, 24 May 2017 16:43:20 +0000
Message-ID: <1495644199.2823.30.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-13-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22559 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163431AbdEXQnW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:43:22 -0400
In-Reply-To: <20170523131931.1777-13-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <6C7BBC694472EA469CD6510A4087866E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
>  	if (lport->port_id !=3D ntoh24(fh->fh_d_id) && !vn_port) {
> -		QEDF_ERR(&(qedf->dbg_ctx), "Dropping frame due to "
> -		    "destination mismatch: lport->port_id=3D%x "
> -		    "fh->d_id=3D%x.\n",
> +		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2,
> +		    "Dropping frame due to destination mismatch: "
> +		    "lport->port_id=3D%x fh->d_id=3D%x.\n",
>  		    lport->port_id, ntoh24(fh->fh_d_id));
>  		kfree_skb(skb);
>  		return;

Hello Chad,

Please consider to keep the above error message on a single line.

Thanks,

Bart.=
