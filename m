From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 00/20] lpfc: Update lpfc driver to revision 10.5.0.0
Date: Fri, 10 Apr 2015 08:41:29 +0200
Message-ID: <55277099.9010104@suse.de>
References: <55242adb.qr1UDF9+UzxYcWLh%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356AbbDJGlc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Apr 2015 02:41:32 -0400
In-Reply-To: <55242adb.qr1UDF9+UzxYcWLh%james.smart@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org

On 04/07/2015 09:07 PM, James Smart wrote:
>=20
> This patch set updates the lpfc driver to revision 10.5.0.0
>=20
> This is version 3.
>=20
> v3 changes:
>   revised comment on patch10 to remove Emulex BZ # that was irrelevan=
t
>   dropped prior patch15: "Implement support for wire-only DIF devices=
"
>=20
> v2 changes:
>   Patches recut with the signed-by's reordered
>   Additional comments added on some patches.
>   Prior Patch 9 and 10 have minor 1 line changes per review comments
>=20
>=20
> The patches were cut against Christoph's scsi-queue.git,
> branch "drivers-for-3.20".
>=20
>=20
> -- james s
>=20
>=20
>=20
> *** BLURB HERE ***
>=20
> James Smart (20):
>   Fix the iteration count to match the 30 sec comment in the routine
>     lpfc_pci_function_reset
>   Add Lancer Temperature Event support to the lpfc driver
>   Add new mbx cmd recognition
>   Fix to handle PLOGI when already logged in
>   Linux lpfc driver doesn't re-establish the link after a cable pull =
on
>     LPe12002
>   Fix host reset escalation killing all IOs.
>   Fix setting of EQ (interrupt) delay Multiplier
>   Add support for reporting option_rom_version on newer adapters
>   Parse the new 20G, 25G and 40G link speeds in the lpfc driver
>   Fix provide host name and OS name in RSNN-NN FC-GS command
>   Fix FDMI Fabric support in driver for Brocade
>   Fix null ndlp dereference in target_reset_handler
>   Initiator sends wrong BBCredit value for either FLOGI or FLOGI_ACC
>   Fix premature release of rpi bit in bitmask
>   Fix internal loopback failure.
>   Fix OS crash when running loopback test in applications
>   Fix crash in device reset handler.
>   Fix for lun discovery issue with saturn adapter.
>   Update copyright to 2015
>   Update version  to 10.5.0.0 for upstream patch set
>=20
>  drivers/scsi/lpfc/lpfc.h           |   5 +-
>  drivers/scsi/lpfc/lpfc_attr.c      |  25 +-
>  drivers/scsi/lpfc/lpfc_bsg.c       |   4 +-
>  drivers/scsi/lpfc/lpfc_bsg.h       |   3 +-
>  drivers/scsi/lpfc/lpfc_crtn.h      |   4 +-
>  drivers/scsi/lpfc/lpfc_ct.c        | 738 +++++++++++++++++++++++++++=
+---------
>  drivers/scsi/lpfc/lpfc_debugfs.c   |   2 +-
>  drivers/scsi/lpfc/lpfc_els.c       |  19 +-
>  drivers/scsi/lpfc/lpfc_hbadisc.c   |  74 +++-
>  drivers/scsi/lpfc/lpfc_hw.h        | 208 +++++------
>  drivers/scsi/lpfc/lpfc_hw4.h       |   8 +-
>  drivers/scsi/lpfc/lpfc_init.c      | 264 +++++++++----
>  drivers/scsi/lpfc/lpfc_mbox.c      |   2 +-
>  drivers/scsi/lpfc/lpfc_nportdisc.c |  29 +-
>  drivers/scsi/lpfc/lpfc_scsi.c      |  83 +++--
>  drivers/scsi/lpfc/lpfc_scsi.h      |   2 +-
>  drivers/scsi/lpfc/lpfc_sli.c       |  72 +++-
>  drivers/scsi/lpfc/lpfc_sli.h       |   3 +-
>  drivers/scsi/lpfc/lpfc_sli4.h      |   4 +-
>  drivers/scsi/lpfc/lpfc_version.h   |   6 +-
>  20 files changed, 1099 insertions(+), 456 deletions(-)
>=20
As the DIF patch has been dropped:

Reviewed-by: Hannes Reinecke <hare@suse.de>

for the whole series.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
