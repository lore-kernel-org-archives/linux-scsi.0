From: =?KOI8-R?B?4czFy9PBzsTSIOTP0snG?= <dorif11@gmail.com>
Subject: HP Smart Array troubles
Date: Mon, 8 Feb 2010 21:46:55 +0200
Message-ID: <b27912b51002081146k3bc5f978tcdfc2a9815a3209a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58489 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab0BHTq6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2010 14:46:58 -0500
Received: by bwz19 with SMTP id 19so69597bwz.28
        for <linux-scsi@vger.kernel.org>; Mon, 08 Feb 2010 11:46:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello! I just compiled linux kernel 2.6.33-rc7 and get this warning:
WARNING: drivers/scsi/hpsa.o(.text+0x1cad): Section mismatch in
reference from the function hpsa_pci_init() to the function
.devinit.text:hpsa_interrupt_mode()
The function hpsa_pci_init() references
the function __devinit hpsa_interrupt_mode().
This is often because hpsa_pci_init lacks a __devinit
annotation or the annotation of hpsa_interrupt_mode is wrong.

I hope it'll be corrected soon. Thank you for attention.
Sincerelly, Alexandr.
P.S.: Sorry for my poor English.
