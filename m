From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] gdth: convert to PCI hotplug API
Date: Fri, 15 Feb 2008 14:50:18 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802151450020.30301@fbirervta.pbzchgretzou.qr>
References: <20080212234928.GA13892@havoc.gtf.org> <47B2CF57.9030308@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49870 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbYBONuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2008 08:50:19 -0500
In-Reply-To: <47B2CF57.9030308@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>


On Feb 13 2008 13:07, Boaz Harrosh wrote:
>+static struct pci_device_id gdthtable[] __devinitdata = {
>+	{ PCI_VDEVICE(VORTEX, PCI_ANY_ID) },
>+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SRC) },
>+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SRC_XSCALE) },
>+	{ }	/* terminate list */
>+};

As usual, +const and +__devinitconst :-)

