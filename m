From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 10/15] qedf: Add non-offload receive filters.
Date: Wed, 24 May 2017 16:39:07 +0000
Message-ID: <1495643946.2823.26.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-11-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:5707 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751722AbdEXQjJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:39:09 -0400
In-Reply-To: <20170523131931.1777-11-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <7FB7BD70D5733E4CA4351821604E2C3E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> +	if (ntoh24(&dest_mac[3]) !=3D ntoh24(fh->fh_d_id)) {
> +		QEDF_ERR(&(qedf->dbg_ctx), "FC frame d_id mismatch with MAC "
> +		    "%pM.\n", dest_mac);
> [ ... ]
> +			QEDF_ERR(&(qedf->dbg_ctx), "Wrong source address: "
> +			    "mac:%pM dest_addr:%pM.\n", mac,
> +			    qedf->ctlr.dest_addr);

Hello Chad,

Are you aware that the 80 column limit does not hold for error messages
and that the recommended style is to keep these on a single line?

Bart.=
