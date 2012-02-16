From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] [trivial] qla2xxx: Fix typo in qla_init.c
Date: Thu, 16 Feb 2012 17:07:59 -0500
Message-ID: <alpine.WNT.2.00.1202161704120.1748@N5102REMCQXM4BS.qlogic.org>
References: <1328986842-24384-1-git-send-email-armin76@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="274924-12016-1329430081=:1748"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:51760
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751487Ab2BPWIK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2012 17:08:10 -0500
In-Reply-To: <1328986842-24384-1-git-send-email-armin76@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-15?Q?Ra=FAl_Porcel?= <armin76@gentoo.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--274924-12016-1329430081=:1748
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable

Looks good. Thanks.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

On Sat, 11 Feb 2012, Ra=C3=BAl Porcel wrote:

> Replace "Inconisistent" with "Inconsistent" in
> drivers/scsi/qla2xxx/qla_init.c
>
> Signed-off-by: Ra=C3=BAl Porcel <armin76@gentoo.org>
> ---
> drivers/scsi/qla2xxx/qla_init.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 1fa067e..72f7aa3 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2230,7 +2230,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
>           nv->id[2] !=3D 'P' || nv->id[3] !=3D ' ' || nv->nvram_version <=
 1) {
>               /* Reset NVRAM data. */
>               ql_log(ql_log_warn, vha, 0x0064,
> -                 "Inconisistent NVRAM "
> +                 "Inconsistent NVRAM "
>                   "detected: checksum=3D0x%x id=3D%c version=3D0x%x.\n",
>                   chksum, nv->id[0], nv->nvram_version);
>               ql_log(ql_log_warn, vha, 0x0065,
> @@ -4425,7 +4425,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
>           nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
>               /* Reset NVRAM data. */
>               ql_log(ql_log_warn, vha, 0x006b,
> -                 "Inconisistent NVRAM detected: checksum=3D0x%x id=3D%c =
"
> +                 "Inconsistent NVRAM detected: checksum=3D0x%x id=3D%c "
>                   "version=3D0x%x.\n", chksum, nv->id[0], nv->nvram_versi=
on);
>               ql_log(ql_log_warn, vha, 0x006c,
>                   "Falling back to functioning (yet invalid -- WWPN) "
> @@ -5169,7 +5169,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
>           nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
>               /* Reset NVRAM data. */
>               ql_log(ql_log_info, vha, 0x0073,
> -                 "Inconisistent NVRAM detected: checksum=3D0x%x id=3D%c =
"
> +                 "Inconsistent NVRAM detected: checksum=3D0x%x id=3D%c "
>                   "version=3D0x%x.\n", chksum, nv->id[0],
>                   le16_to_cpu(nv->nvram_version));
>               ql_log(ql_log_info, vha, 0x0074,
>

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--274924-12016-1329430081=:1748--
