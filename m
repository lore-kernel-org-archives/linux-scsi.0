From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 9/9] snic:Add Makefile, patch Kconfig, MAINTAINERS
Date: Wed, 25 Mar 2015 12:16:55 +0100
Message-ID: <55129927.3040008@suse.de>
References: <1426093299-4511-1-git-send-email-nmusini@cisco.com> <1426093299-4511-10-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbbCYLQ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2015 07:16:56 -0400
In-Reply-To: <1426093299-4511-10-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

Hi Narsimhulu,

On 03/11/2015 06:01 PM, Narsimhulu Musini wrote:
> Kconfig for kbuild
> Makefile to build snic module
>=20
> Updated MAINTAINERS file
>=20
> v2
> Added compile time flags for debugfs dependent functionality.
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---
>  MAINTAINERS                |  7 +++++++
>  drivers/scsi/Kconfig       | 10 ++++++++++
>  drivers/scsi/Makefile      |  1 +
>  drivers/scsi/snic/Makefile | 21 +++++++++++++++++++++
>  4 files changed, 39 insertions(+)
>  create mode 100644 drivers/scsi/snic/Makefile
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2a97e05..368fb76 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2536,6 +2536,13 @@ L:	linux-scsi@vger.kernel.org
>  S:	Supported
>  F:	drivers/scsi/fnic/
> =20
> +CISCO SCSI HBA DRIVER
> +M:	Narsimhulu Musini <nmusini@cisco.com>
> +M:	Sesidhar Baddela <sebaddel@cisco.com>
> +L:	linux-scsi@vger.kernel.org
> +S:	Supported
> +F:	drivers/scsi/snic/
> +
>  CMPC ACPI DRIVER
>  M:	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>  M:	Daniel Oliveira Nascimento <don@syst.com.br>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 9c92f41..7e9d80a 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -634,6 +634,16 @@ config FCOE_FNIC
>  	  <file:Documentation/scsi/scsi.txt>.
>  	  The module will be called fnic.
> =20
> +config SCSI_SNIC
> +	tristate "Cisco SNIC Driver"
> +	depends on PCI && SCSI && X86
> +	help
> +	  This is support for the Cisco PCI-Express SCSI HBA.
> +
> +	  To compile this driver as a module, choose M here and read
> +	  <file:Documentation/scsi/scsi.txt>.
> +	  The module will be called snic.
> +
>  config SCSI_DMX3191D
>  	tristate "DMX3191D SCSI support"
>  	depends on PCI && SCSI
Please add an additional config section for enabling debugging
functionality; I'd rather not have it enabled automatically
depending on CONFIG_FS.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
