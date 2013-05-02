From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/5] bnx2fc: Include chip number in the symbolic name
Date: Wed, 01 May 2013 17:39:53 -0700
Message-ID: <1367455193.26485.0.camel@dabdike>
References: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
	 <1362778134-21045-3-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49581 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab3EBAj6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 May 2013 20:39:58 -0400
In-Reply-To: <1362778134-21045-3-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2013-03-08 at 13:28 -0800, Bhanu Prakash Gollapudi wrote:
> +#ifndef PCI_DEVICE_ID_NX2_57710
> +#define PCI_DEVICE_ID_NX2_57710		0x164e
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57711
> +#define PCI_DEVICE_ID_NX2_57711		0x164f
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57712
> +#define PCI_DEVICE_ID_NX2_57712		0x1662
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57712_MF
> +#define PCI_DEVICE_ID_NX2_57712_MF	0x1663
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57712_VF
> +#define PCI_DEVICE_ID_NX2_57712_VF	0x166f
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57800
> +#define PCI_DEVICE_ID_NX2_57800		0x168a
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57800_MF
> +#define PCI_DEVICE_ID_NX2_57800_MF	0x16a5
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57800_VF
> +#define PCI_DEVICE_ID_NX2_57800_VF	0x16a9
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57810
> +#define PCI_DEVICE_ID_NX2_57810		0x168e
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57810_MF
> +#define PCI_DEVICE_ID_NX2_57810_MF	0x16ae
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57810_VF
> +#define PCI_DEVICE_ID_NX2_57810_VF	0x16af
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57840
> +#define PCI_DEVICE_ID_NX2_57840		0x168d
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57840_MF
> +#define PCI_DEVICE_ID_NX2_57840_MF	0x16a4
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57840_VF
> +#define PCI_DEVICE_ID_NX2_57840_VF	0x16ad
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57840_2_20
> +#define PCI_DEVICE_ID_NX2_57840_2_20	0x16a2
> +#endif
> +#ifndef PCI_DEVICE_ID_NX2_57840_4_10
> +#define PCI_DEVICE_ID_NX2_57840_4_10	0x16a1
> +#endif

This doesn't belong in your header file.  Most of the IDs are already in
pci_ids.h; I added the few which weren't.

James


