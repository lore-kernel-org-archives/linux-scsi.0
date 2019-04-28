From: Ondrej Zary <linux@zary.sk>
Subject: [PATCH 0/4] fdomain: Resurrect driver (modular version)
Date: Sun, 28 Apr 2019 22:06:22 +0200
Message-ID: <20190428200626.28092-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik Faith <faith@cs.unc.edu>, "David A . Hinds" <dahinds@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Resurrect previously removed fdomain driver, in modern style.
Initialization is rewritten completely, with support for multiple cards,
no more global state variables.
Most of the code from interrupt handler is moved to a workqueue.

This is a modularized version with core separated from bus-specific drivers
(PCI, ISA and PCMCIA). Only PCI driver is tested for now. The other two could
be dropped until they get tested.

Changes since RFC:
 - multi-line comment style, some coding style
 - usage of scsi_k(un)map_atomic_sg for buffer access
 - static marking of fdomain_host_reset and fdomain_template
 - IRQ lookup moved to ISA bus driver
 - EXPORT_SYMBOL_GPL

-- 
Ondrej Zary
