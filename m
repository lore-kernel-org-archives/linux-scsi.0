From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 15/15] qedf: Update version number to 8.18.22.0.
Date: Wed, 24 May 2017 16:51:13 +0000
Message-ID: <1495644672.2823.33.camel@sandisk.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
         <20170523131931.1777-16-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:55994 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968090AbdEXQvP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2017 12:51:15 -0400
In-Reply-To: <20170523131931.1777-16-chad.dupuis@cavium.com>
Content-Language: en-US
Content-ID: <0AE2C2D6924D844C8CDE7D1175957A00@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "chad.dupuis@cavium.com" <chad.dupuis@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

On Tue, 2017-05-23 at 06:19 -0700, Dupuis, Chad wrote:
> Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
> ---
>  drivers/scsi/qedf/qedf_version.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qedf/qedf_version.h b/drivers/scsi/qedf/qedf_ve=
rsion.h
> index d46c487..6fa4420 100644
> --- a/drivers/scsi/qedf/qedf_version.h
> +++ b/drivers/scsi/qedf/qedf_version.h
> @@ -7,9 +7,9 @@
>   *  this source tree.
>   */
> =20
> -#define QEDF_VERSION		"8.10.7.0"
> +#define QEDF_VERSION		"8.18.22.0"
>  #define QEDF_DRIVER_MAJOR_VER		8
> -#define QEDF_DRIVER_MINOR_VER		10
> -#define QEDF_DRIVER_REV_VER		7
> +#define QEDF_DRIVER_MINOR_VER		18
> +#define QEDF_DRIVER_REV_VER		22
>  #define QEDF_DRIVER_ENG_VER		0
> =20

Although I'm not sure having driver version information in an upstream
driver is useful:

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
