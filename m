From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 1/3] scsi: aacraid: Check for PCI state of device in a
 generic way
Date: Fri, 17 Nov 2017 22:54:01 +0000
Message-ID: <a247adb0ad0e4e07809760939c468899@microsemi.com>
References: <20171117211455.29031-1-gpiccoli@linux.vnet.ibm.com>
 <20171117211455.29031-2-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0057.outbound.protection.outlook.com ([104.47.42.57]:33696
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964905AbdKQWyF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Nov 2017 17:54:05 -0500
In-Reply-To: <20171117211455.29031-2-gpiccoli@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "gpiccoli@protonmail.ch" <gpiccoli@protonmail.ch>

> Commit 16ae9dd35d37 ("scsi: aacraid: Fix for excessive prints on EEH")
> introduced checks about the state of device before any PCI operations
> in the driver. Basically, this prevents it to perform PCI accesses
> when device is in the process of recover from a PCI error. In PowerPC,
> such mechanism is called EEH, and the aforementioned commit introduced
> checks that are based on EEH-specific primitives for that.
>=20
> The potential problems with this approach are three: first, these checks
> are "locked" to powerpc only - another archs could have error recovery
> methods too, like AER in Intel. Also, the powerpc primitives perform
> expensive FW accesses to validate the precise PCI state of a device.
> Finally, code becomes more complicated and needs ifdef validation
> based on arch config being set.
>=20
> So, this patch makes use of generic PCI state checks, which are
> lightweight and non-dependent of arch configs - also, it makes
> the code cleaner.
>=20
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
> ---

Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
