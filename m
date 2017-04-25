From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 18/37] smartpqi: cleanup messages
Date: Tue, 25 Apr 2017 20:11:26 +0000
Message-ID: <1493151084.2628.17.camel@sandisk.com>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314966189.13903.16638515102195812930.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26471 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1949022AbdDYUL3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 16:11:29 -0400
In-Reply-To: <149314966189.13903.16638515102195812930.stgit@brunhilda>
Content-Language: en-US
Content-ID: <21BA0289516424439CC79F1157E1EB96@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "Viswas.G@microsemi.com" <Viswas.G@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "Mahesh.Rajashekhara@microsemi.com" <Mahesh.Rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "Kevin.Barnett@microsemi.com" <Kevin.Barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Justin.Lindley@microsemi.com" <Justin.Lindley@microsemi.com>, "john.hall@microsemi.com" <john.hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-04-25 at 14:47 -0500, Don Brace wrote:
>  	case CISS_LV_ENCRYPTED_IN_NON_ENCRYPTED_CONTROLLER:
>  		status =3D
> -			"Encrypted volume inaccessible - disabled on ctrl";
> +		"Volume encrypted but encryption disabled on controller";
>  		break;

This indentation style is confusing. Please don't do this.

Thanks,

Bart.=
