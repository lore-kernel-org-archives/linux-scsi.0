From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of the staging area
Date: Thu, 26 Jan 2012 18:17:02 +0100
Message-ID: <4414328.OlPOtXe4lZ@eto>
References: <1327516187-21793-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2296618.8EdTuqZGIM"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1327516187-21793-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--nextPart2296618.8EdTuqZGIM
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Mittwoch 25 Januar 2012, 10:29:47 schrieb K. Y. Srinivasan:
> The storage driver (storvsc_drv.c) handles all block storage devices
> assigned to Linux guests hosted on Hyper-V. This driver has been in the
> staging tree for a while and this patch moves it out of the staging area.
> 
> This patch is based on the storvsc patches that are already on Greg's queue
> for the staging tree. This patch-set addressed Christoph's review comments.
> If need be, I can re-send this patch-set in Greg's queue
> or I can  send the fully patched storvsc_drv.c.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/Kconfig                       |    7 +++++++
>  drivers/scsi/Makefile                      |    3 +++
>  drivers/{staging/hv => scsi}/storvsc_drv.c |    0
>  3 files changed, 10 insertions(+), 0 deletions(-)
>  rename drivers/{staging/hv => scsi}/storvsc_drv.c (100%)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 16570aa..d3d18e8 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -662,6 +662,13 @@ config VMWARE_PVSCSI
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vmw_pvscsi.
> 
> +config HYPERV_STORAGE
> +	tristate "Microsoft Hyper-V virtual storage driver"
> +	depends on SCSI && HYPERV
> +	default HYPERV
> +	help
> +	  Select this option to enable the Hyper-V virtual storage driver.
> +
>  config LIBFC
>  	tristate "LibFC module"
>  	select SCSI_FC_ATTRS
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 2b88749..e4c1a69 100644

I still miss a "this driver will be called ..." message here, as it is used 
e.g. by the entry before:

>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vmw_pvscsi.

Eike
--nextPart2296618.8EdTuqZGIM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk8hipQACgkQXKSJPmm5/E47fwCeLkwc81RH61GNDCFr7QTD1rpT
W/sAn3EGkVbcLskF21oYsfrCFZ8hDYQD
=Q4s+
-----END PGP SIGNATURE-----

--nextPart2296618.8EdTuqZGIM--
