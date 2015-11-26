From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/4] bfa:File header and user visible string changes
Date: Thu, 26 Nov 2015 09:36:28 +0100
Message-ID: <1448526988.2877.87.camel@suse.de>
References: <1448523815-24562-1-git-send-email-anil.gurumurthy@qlogic.com>
	 <1448523815-24562-4-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbbKZIga (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2015 03:36:30 -0500
In-Reply-To: <1448523815-24562-4-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil.gurumurthy@qlogic.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com

On Thu, 2015-11-26 at 02:43 -0500, anil.gurumurthy@qlogic.com wrote:
> From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
>=20
> Signed-off-by: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
> ---
> =C2=A0drivers/scsi/bfa/bfa.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_core.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_cs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_defs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_defs_fcs.h=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=
=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_defs_svc.h=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=
=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_fc.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_fcbuild.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=
=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_fcbuild.h=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=
=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_fcpim.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=
=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_fcpim.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=
=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_fcs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_fcs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A0=C2=A04 +-
> =C2=A0drivers/scsi/bfa/bfa_fcs_fcpim.c |=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_fcs_lport.c |=C2=A0=C2=A0=C2=A0=C2=A04 +-
> =C2=A0drivers/scsi/bfa/bfa_fcs_rport.c |=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_hw_cb.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=
=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_hw_ct.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=
=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_ioc.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A0=C2=A04 +-
> =C2=A0drivers/scsi/bfa/bfa_ioc.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_ioc_cb.c=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=
=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_ioc_ct.c=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=
=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_modules.h=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=
=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_plog.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_port.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_port.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_svc.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfa_svc.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfad.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A019 ++++------
> =C2=A0drivers/scsi/bfa/bfad_attr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=
=C2=A0=C2=A070 +++++++++++++++++++-----------------
> --
> =C2=A0drivers/scsi/bfa/bfad_bsg.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfad_bsg.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfad_debugfs.c=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=
=A02 +-
> =C2=A0drivers/scsi/bfa/bfad_drv.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfad_im.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A0=C2=A04 +-
> =C2=A0drivers/scsi/bfa/bfad_im.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfi.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfi_ms.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02 +-
> =C2=A0drivers/scsi/bfa/bfi_reg.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A0=C2=A04 +-
> =C2=A039 files changed, 84 insertions(+), 89 deletions(-)
>=20
> diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
> index 7d0337b..0e119d8 100644
> --- a/drivers/scsi/bfa/bfa.h
> +++ b/drivers/scsi/bfa/bfa.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.=
c
> index f157a37..2ea0db4 100644
> --- a/drivers/scsi/bfa/bfa_core.c
> +++ b/drivers/scsi/bfa/bfa_core.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h
> index c8bb20a..da9cf65 100644
> --- a/drivers/scsi/bfa/bfa_cs.h
> +++ b/drivers/scsi/bfa/bfa_cs.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_defs.h b/drivers/scsi/bfa/bfa_defs.=
h
> index da4f705..5dc3782 100644
> --- a/drivers/scsi/bfa/bfa_defs.h
> +++ b/drivers/scsi/bfa/bfa_defs.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_defs_fcs.h
> b/drivers/scsi/bfa/bfa_defs_fcs.h
> index 5185ae3..5815a90 100644
> --- a/drivers/scsi/bfa/bfa_defs_fcs.h
> +++ b/drivers/scsi/bfa/bfa_defs_fcs.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_defs_svc.h
> b/drivers/scsi/bfa/bfa_defs_svc.h
> index fd2fa24..e81707f 100644
> --- a/drivers/scsi/bfa/bfa_defs_svc.h
> +++ b/drivers/scsi/bfa/bfa_defs_svc.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
> index 7142309..18b7304 100644
> --- a/drivers/scsi/bfa/bfa_fc.h
> +++ b/drivers/scsi/bfa/bfa_fc.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fc=
build.c
> index 6f670d3..b8dadc9 100644
> --- a/drivers/scsi/bfa/bfa_fcbuild.c
> +++ b/drivers/scsi/bfa/bfa_fcbuild.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_fcbuild.h b/drivers/scsi/bfa/bfa_fc=
build.h
> index 85e3c58..b109a88 100644
> --- a/drivers/scsi/bfa/bfa_fcbuild.h
> +++ b/drivers/scsi/bfa/bfa_fcbuild.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpi=
m.c
> index 3881a72..20982e7 100644
> --- a/drivers/scsi/bfa/bfa_fcpim.c
> +++ b/drivers/scsi/bfa/bfa_fcpim.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpi=
m.h
> index 0c37062..e93921d 100644
> --- a/drivers/scsi/bfa/bfa_fcpim.h
> +++ b/drivers/scsi/bfa/bfa_fcpim.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
> index 043d3c0..1e7e139 100644
> --- a/drivers/scsi/bfa/bfa_fcs.c
> +++ b/drivers/scsi/bfa/bfa_fcs.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
> index 30b4555..06dc215 100644
> --- a/drivers/scsi/bfa/bfa_fcs.h
> +++ b/drivers/scsi/bfa/bfa_fcs.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> @@ -634,7 +634,7 @@ void bfa_fcs_fcpim_uf_recv(struct bfa_fcs_itnim_s=
 *itnim,
> =C2=A0
> =C2=A0/*
> =C2=A0 * HBA Attribute Block : BFA internal representation. Note : So=
me variable
> - * sizes have been trimmed to suit BFA For Ex : Model will be "Broca=
de".
> Based
> + * sizes have been trimmed to suit BFA For Ex : Model will be "QLogi=
c ".
> Based
> =C2=A0 * on this the size has been reduced to 16 bytes from the stand=
ard's 64
> bytes.
> =C2=A0 */
> =C2=A0struct bfa_fcs_fdmi_hba_attr_s {
> diff --git a/drivers/scsi/bfa/bfa_fcs_fcpim.c
> b/drivers/scsi/bfa/bfa_fcs_fcpim.c
> index 4fd20d9..4f089d7 100644
> --- a/drivers/scsi/bfa/bfa_fcs_fcpim.c
> +++ b/drivers/scsi/bfa/bfa_fcs_fcpim.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c
> b/drivers/scsi/bfa/bfa_fcs_lport.c
> index d823792..7733ad5 100644
> --- a/drivers/scsi/bfa/bfa_fcs_lport.c
> +++ b/drivers/scsi/bfa/bfa_fcs_lport.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> @@ -2654,7 +2654,7 @@ bfa_fcs_fdmi_get_hbaattr(struct bfa_fcs_lport_f=
dmi_s
> *fdmi,
> =C2=A0
> =C2=A0	strncpy(hba_attr->node_sym_name.symname,
> =C2=A0		port->port_cfg.node_sym_name.symname, BFA_SYMNAME_MAXLEN);
> -	strcpy(hba_attr->vendor_info, "BROCADE");
> +	strcpy(hba_attr->vendor_info, "QLogic");
> =C2=A0	hba_attr->num_ports =3D
> =C2=A0		cpu_to_be32(bfa_ioc_get_nports(&port->fcs->bfa->ioc));
> =C2=A0	hba_attr->fabric_name =3D port->fabric->lps->pr_nwwn;
> diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c
> b/drivers/scsi/bfa/bfa_fcs_rport.c
> index 5559faa..de50349 100644
> --- a/drivers/scsi/bfa/bfa_fcs_rport.c
> +++ b/drivers/scsi/bfa/bfa_fcs_rport.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_hw_cb.c b/drivers/scsi/bfa/bfa_hw_c=
b.c
> index e3648d9..c4a0c0e 100644
> --- a/drivers/scsi/bfa/bfa_hw_cb.c
> +++ b/drivers/scsi/bfa/bfa_hw_cb.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_hw_ct.c b/drivers/scsi/bfa/bfa_hw_c=
t.c
> index f19bc44..b0ff378 100644
> --- a/drivers/scsi/bfa/bfa_hw_ct.c
> +++ b/drivers/scsi/bfa/bfa_hw_ct.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
> index e9a7c64..251e2ff 100644
> --- a/drivers/scsi/bfa/bfa_ioc.c
> +++ b/drivers/scsi/bfa/bfa_ioc.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> @@ -2698,7 +2698,7 @@ bfa_ioc_reset_fwstate(struct bfa_ioc_s *ioc)
> =C2=A0	bfa_ioc_set_alt_ioc_fwstate(ioc, BFI_IOC_UNINIT);
> =C2=A0}
> =C2=A0
> -#define BFA_MFG_NAME "Brocade"
> +#define BFA_MFG_NAME "QLogic"
> =C2=A0void
> =C2=A0bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
> =C2=A0			=C2=A0struct bfa_adapter_attr_s *ad_attr)
> diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
> index 0d6e165..713745d 100644
> --- a/drivers/scsi/bfa/bfa_ioc.h
> +++ b/drivers/scsi/bfa/bfa_ioc.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc=
_cb.c
> index 10a0042..f1b80da 100644
> --- a/drivers/scsi/bfa/bfa_ioc_cb.c
> +++ b/drivers/scsi/bfa/bfa_ioc_cb.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc=
_ct.c
> index 1e5fa61..651a8fb 100644
> --- a/drivers/scsi/bfa/bfa_ioc_ct.c
> +++ b/drivers/scsi/bfa/bfa_ioc_ct.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_mo=
dules.h
> index 5b02415..53135f2 100644
> --- a/drivers/scsi/bfa/bfa_modules.h
> +++ b/drivers/scsi/bfa/bfa_modules.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_plog.h b/drivers/scsi/bfa/bfa_plog.=
h
> index 4fdba6f..da570c0 100644
> --- a/drivers/scsi/bfa/bfa_plog.h
> +++ b/drivers/scsi/bfa/bfa_plog.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.=
c
> index 314548a..da1721e 100644
> --- a/drivers/scsi/bfa/bfa_port.c
> +++ b/drivers/scsi/bfa/bfa_port.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_port.h b/drivers/scsi/bfa/bfa_port.=
h
> index ba715ce..26dc1bf 100644
> --- a/drivers/scsi/bfa/bfa_port.h
> +++ b/drivers/scsi/bfa/bfa_port.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
> index 93e588f..12de292 100644
> --- a/drivers/scsi/bfa/bfa_svc.c
> +++ b/drivers/scsi/bfa/bfa_svc.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
> index efb0497..ea2278b 100644
> --- a/drivers/scsi/bfa/bfa_svc.h
> +++ b/drivers/scsi/bfa/bfa_svc.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
> index f298b2e..9d253cb 100644
> --- a/drivers/scsi/bfa/bfad.c
> +++ b/drivers/scsi/bfa/bfad.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> @@ -131,13 +131,9 @@ MODULE_PARM_DESC(bfa_linkup_delay, "Link up dela=
y,
> default=3D30 secs for "
> =C2=A0			"boot port. Otherwise 10 secs in RHEL4 & 0 for "
> =C2=A0			"[RHEL5, SLES10, ESX40] Range[>0]");
> =C2=A0module_param(msix_disable_cb, int, S_IRUGO | S_IWUSR);
> -MODULE_PARM_DESC(msix_disable_cb, "Disable Message Signaled Interrup=
ts "
> -			"for Brocade-415/425/815/825 cards, default=3D0, "
> -			" Range[false:0|true:1]");
> +MODULE_PARM_DESC(msix_disable_cb, "Disable Message Signaled Interrup=
ts for
> QLogic-415/425/815/825 cards, default=3D0 Range[false:0|true:1]");
> =C2=A0module_param(msix_disable_ct, int, S_IRUGO | S_IWUSR);
> -MODULE_PARM_DESC(msix_disable_ct, "Disable Message Signaled Interrup=
ts "
> -			"if possible for Brocade-1010/1020/804/1007/902/1741=20
> "
> -			"cards, default=3D0, Range[false:0|true:1]");
> +MODULE_PARM_DESC(msix_disable_ct, "Disable Message Signaled Interrup=
ts if
> possible for QLogic-1010/1020/804/1007/902/1741 cards, default=3D0,
> Range[false:0|true:1]");
> =C2=A0module_param(fdmi_enable, int, S_IRUGO | S_IWUSR);
> =C2=A0MODULE_PARM_DESC(fdmi_enable, "Enables fdmi registration, defau=
lt=3D1, "
> =C2=A0				"Range[false:0|true:1]");
> @@ -839,8 +835,7 @@ bfad_drv_init(struct bfad_s *bfad)
> =C2=A0		printk(KERN_WARNING "bfad%d bfad_hal_mem_alloc failure\n",
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bfad->inst_no);
> =C2=A0		printk(KERN_WARNING
> -			"Not enough memory to attach all Brocade HBA ports,
> %s",
> -			"System may need more memory.\n");
> +			"Not enough memory to attach all QLogic BR-series
> HBA ports. System may need more memory.\n");
> =C2=A0		return BFA_STATUS_FAILED;
> =C2=A0	}
> =C2=A0
> @@ -1711,7 +1706,7 @@ bfad_init(void)
> =C2=A0{
> =C2=A0	int		error =3D 0;
> =C2=A0
> -	printk(KERN_INFO "Brocade BFA FC/FCOE SCSI driver - version: %s\n",
> +	pr_info("QLogic BR-series BFA FC/FCOE SCSI driver - version: %s\n",
> =C2=A0			BFAD_DRIVER_VERSION);
> =C2=A0
> =C2=A0	if (num_sgpgs > 0)
> @@ -1818,6 +1813,6 @@ bfad_free_fwimg(void)
> =C2=A0module_init(bfad_init);
> =C2=A0module_exit(bfad_exit);
> =C2=A0MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("Brocade Fibre Channel HBA Driver" BFAD_PROTO_NAM=
E);
> -MODULE_AUTHOR("Brocade Communications Systems, Inc.");
> +MODULE_DESCRIPTION("QLogic BR-series Fibre Channel HBA Driver"
> BFAD_PROTO_NAME);
> +MODULE_AUTHOR("QLogic Corporation");
> =C2=A0MODULE_VERSION(BFAD_DRIVER_VERSION);
> diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_att=
r.c
> index 66cca48..13db3b7 100644
> --- a/drivers/scsi/bfa/bfad_attr.c
> +++ b/drivers/scsi/bfa/bfad_attr.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> @@ -751,65 +751,65 @@ bfad_im_model_desc_show(struct device *dev, str=
uct
> device_attribute *attr,
> =C2=A0
> =C2=A0	bfa_get_adapter_model(&bfad->bfa, model);
> =C2=A0	nports =3D bfa_get_nports(&bfad->bfa);
> -	if (!strcmp(model, "Brocade-425"))
> +	if (!strcmp(model, "QLogic-425"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 4Gbps PCIe dual port FC HBA");
> -	else if (!strcmp(model, "Brocade-825"))
> +			"QLogic BR-series 4Gbps PCIe dual port FC HBA");
> +	else if (!strcmp(model, "QLogic-825"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 8Gbps PCIe dual port FC HBA");
> -	else if (!strcmp(model, "Brocade-42B"))
> +			"QLogic BR-series 8Gbps PCIe dual port FC HBA");
> +	else if (!strcmp(model, "QLogic-42B"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 4Gbps PCIe dual port FC HBA for HP");
> -	else if (!strcmp(model, "Brocade-82B"))
> +			"QLogic BR-series 4Gbps PCIe dual port FC HBA for
> HP");
> +	else if (!strcmp(model, "QLogic-82B"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 8Gbps PCIe dual port FC HBA for HP");
> -	else if (!strcmp(model, "Brocade-1010"))
> +			"QLogic BR-series 8Gbps PCIe dual port FC HBA for
> HP");
> +	else if (!strcmp(model, "QLogic-1010"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 10Gbps single port CNA");
> -	else if (!strcmp(model, "Brocade-1020"))
> +			"QLogic BR-series 10Gbps single port CNA");
> +	else if (!strcmp(model, "QLogic-1020"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 10Gbps dual port CNA");
> -	else if (!strcmp(model, "Brocade-1007"))
> +			"QLogic BR-series 10Gbps dual port CNA");
> +	else if (!strcmp(model, "QLogic-1007"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 10Gbps CNA for IBM Blade Center");
> -	else if (!strcmp(model, "Brocade-415"))
> +			"QLogic BR-series 10Gbps CNA for IBM Blade Center");
> +	else if (!strcmp(model, "QLogic-415"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 4Gbps PCIe single port FC HBA");
> -	else if (!strcmp(model, "Brocade-815"))
> +			"QLogic BR-series 4Gbps PCIe single port FC HBA");
> +	else if (!strcmp(model, "QLogic-815"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 8Gbps PCIe single port FC HBA");
> -	else if (!strcmp(model, "Brocade-41B"))
> +			"QLogic BR-series 8Gbps PCIe single port FC HBA");
> +	else if (!strcmp(model, "QLogic-41B"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 4Gbps PCIe single port FC HBA for HP");
> -	else if (!strcmp(model, "Brocade-81B"))
> +			"QLogic BR-series 4Gbps PCIe single port FC HBA for
> HP");
> +	else if (!strcmp(model, "QLogic-81B"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 8Gbps PCIe single port FC HBA for HP");
> -	else if (!strcmp(model, "Brocade-804"))
> +			"QLogic BR-series 8Gbps PCIe single port FC HBA for
> HP");
> +	else if (!strcmp(model, "QLogic-804"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 8Gbps FC HBA for HP Bladesystem C-class");
> -	else if (!strcmp(model, "Brocade-1741"))
> +			"QLogic BR-series 8Gbps FC HBA for HP Bladesystem C-
> class");
> +	else if (!strcmp(model, "QLogic-1741"))
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -			"Brocade 10Gbps CNA for Dell M-Series Blade
> Servers");
> -	else if (strstr(model, "Brocade-1860")) {
> +			"QLogic BR-series 10Gbps CNA for Dell M-Series Blade
> Servers");
> +	else if (strstr(model, "QLogic-1860")) {
> =C2=A0		if (nports =3D=3D 1 && bfa_ioc_is_cna(&bfad->bfa.ioc))
> =C2=A0			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -				"Brocade 10Gbps single port CNA");
> +				"QLogic BR-series 10Gbps single port CNA");
> =C2=A0		else if (nports =3D=3D 1 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
> =C2=A0			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -				"Brocade 16Gbps PCIe single port FC HBA");
> +				"QLogic BR-series 16Gbps PCIe single port FC
> HBA");
> =C2=A0		else if (nports =3D=3D 2 && bfa_ioc_is_cna(&bfad->bfa.ioc))
> =C2=A0			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -				"Brocade 10Gbps dual port CNA");
> +				"QLogic BR-series 10Gbps dual port CNA");
> =C2=A0		else if (nports =3D=3D 2 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
> =C2=A0			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -				"Brocade 16Gbps PCIe dual port FC HBA");
> -	} else if (!strcmp(model, "Brocade-1867")) {
> +				"QLogic BR-series 16Gbps PCIe dual port FC
> HBA");
> +	} else if (!strcmp(model, "QLogic-1867")) {
> =C2=A0		if (nports =3D=3D 1 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
> =C2=A0			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -				"Brocade 16Gbps PCIe single port FC HBA for
> IBM");
> +				"QLogic BR-series 16Gbps PCIe single port FC
> HBA for IBM");
> =C2=A0		else if (nports =3D=3D 2 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
> =C2=A0			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> -				"Brocade 16Gbps PCIe dual port FC HBA for
> IBM");
> +				"QLogic BR-series 16Gbps PCIe dual port FC
> HBA for IBM");
> =C2=A0	} else
> =C2=A0		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
> =C2=A0			"Invalid Model");
> diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.=
c
> index b9d1460..d1ad020 100644
> --- a/drivers/scsi/bfa/bfad_bsg.c
> +++ b/drivers/scsi/bfa/bfad_bsg.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfad_bsg.h b/drivers/scsi/bfa/bfad_bsg.=
h
> index 59aca80..917e140 100644
> --- a/drivers/scsi/bfa/bfad_bsg.h
> +++ b/drivers/scsi/bfa/bfad_bsg.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfad_debugfs.c
> b/drivers/scsi/bfa/bfad_debugfs.c
> index 62b11d4..8dcd8c7 100644
> --- a/drivers/scsi/bfa/bfad_debugfs.c
> +++ b/drivers/scsi/bfa/bfad_debugfs.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.=
h
> index 58fee34..8001459 100644
> --- a/drivers/scsi/bfa/bfad_drv.h
> +++ b/drivers/scsi/bfa/bfad_drv.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index 2c0cf8a..6c805e1 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> @@ -186,7 +186,7 @@ bfad_im_info(struct Scsi_Host *shost)
> =C2=A0
> =C2=A0	memset(bfa_buf, 0, sizeof(bfa_buf));
> =C2=A0	snprintf(bfa_buf, sizeof(bfa_buf),
> -		"Brocade FC/FCOE Adapter, " "hwpath: %s driver: %s",
> +		"QLogic BR-series FC/FCOE Adapter, hwpath: %s driver: %s",
> =C2=A0		bfad->pci_name, BFAD_DRIVER_VERSION);
> =C2=A0
> =C2=A0	return bfa_buf;
> diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
> index 31434df..836fdc2 100644
> --- a/drivers/scsi/bfa/bfad_im.h
> +++ b/drivers/scsi/bfa/bfad_im.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
> index 54c93ef..97600dc 100644
> --- a/drivers/scsi/bfa/bfi.h
> +++ b/drivers/scsi/bfa/bfi.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfi_ms.h b/drivers/scsi/bfa/bfi_ms.h
> index 8699be4..ae5bfe0 100644
> --- a/drivers/scsi/bfa/bfi_ms.h
> +++ b/drivers/scsi/bfa/bfi_ms.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> diff --git a/drivers/scsi/bfa/bfi_reg.h b/drivers/scsi/bfa/bfi_reg.h
> index 7d071a4..fd5b876 100644
> --- a/drivers/scsi/bfa/bfi_reg.h
> +++ b/drivers/scsi/bfa/bfi_reg.h
> @@ -4,7 +4,7 @@
> =C2=A0 * All rights reserved
> =C2=A0 * www.qlogic.com
> =C2=A0 *
> - * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
> =C2=A0 *
> =C2=A0 * This program is free software; you can redistribute it and/o=
r modify it
> =C2=A0 * under the terms of the GNU General Public License (GPL) Vers=
ion 2 as
> @@ -17,7 +17,7 @@
> =C2=A0 */
> =C2=A0
> =C2=A0/*
> - * bfi_reg.h ASIC register defines for all Brocade adapter ASICs
> + * bfi_reg.h ASIC register defines for all QLogic BR-series adapter =
ASICs
> =C2=A0 */
> =C2=A0
> =C2=A0#ifndef __BFI_REG_H__

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
