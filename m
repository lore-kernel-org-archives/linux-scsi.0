From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: aic7xxx: aic7892(B): BUG: soft lockup detected on CPU#0!
Date: Thu, 22 Mar 2007 22:02:13 +0100
Message-ID: <4602EED5.5070503@gmx.de>
References: <46029D72.3060403@gmx.de> <4602B576.6020602@gmx.de>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41056 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752414AbXCVVCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2007 17:02:15 -0400
In-Reply-To: <4602B576.6020602@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

[    0.000000] Linux version 2.6.21-rc3amd64-gbb9ba31c-dirty (root@tom1) (gcc ve
rsion 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #3 PREEMPT Thu Mar 22 21:48
:44 CET 2007

added some traces,
ok it does not return from the first pci_map_registers():

[   42.754305] Loading iSCSI transport class v2.0-724.
[   42.759656] iscsi: registered transport (tcp)
[   42.764016] ahc_linux_pci_init
[   42.767207] ahc_linux_pci_dev_probe
[   42.770744] ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ
 17
[   42.778160] ahc_pci_config
[   42.780861] set_power_state
[   42.783656] map_registers

tracing further and provide args dump if applicable
