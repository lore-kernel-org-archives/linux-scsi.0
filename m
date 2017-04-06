From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH] scsi: aacraid: fix PCI error recovery path
Date: Thu, 6 Apr 2017 21:46:48 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A4EF7F6B4@avsrvexchmbx1.microsemi.net>
References: <20170406211209.27129-1-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0086.outbound.protection.outlook.com ([104.47.33.86]:53664
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751853AbdDFVqz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Apr 2017 17:46:55 -0400
In-Reply-To: <20170406211209.27129-1-gpiccoli@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "Martin K . Petersen (martin.petersen@oracle.com)" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "James Bottomley (jejb@linux.vnet.ibm.com)" <jejb@linux.vnet.ibm.com>

> From: Guilherme G. Piccoli [mailto:gpiccoli@linux.vnet.ibm.com]
> Sent: Thursday, April 06, 2017 3:12 PM
> To: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>
> Cc: gpiccoli@linux.vnet.ibm.com; linux-scsi@vger.kernel.org; Raghava Adit=
ya
> Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Subject: [PATCH] scsi: aacraid: fix PCI error recovery path
>=20
>=20
> During a PCI error recovery, if aac_check_health() is not aware that a PC=
I error
> happened and we have an offline PCI channel, it might trigger some errors=
 (like
> NULL pointer dereference) and inhibit the error recovery process to compl=
ete.
>=20
> This patch makes the health check procedure aware of PCI channel issues, =
and in
> case of error recovery process, the function
> aac_adapter_check_health() returns -1 and let the recovery process to com=
plete
> successfully. This patch was tested on upstream kernel
> v4.11-rc5 in PowerPC ppc64le architecture with adapter 9005:028d
> (VID:DID) - the error recovery procedure was able to recover fine.
>=20
> Fixes: 5c63f7f710bd ("aacraid: Added EEH support")
> Cc: stable@vger.kernel.org # v4.6+
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
> ---
Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
