From: Ondrej Zary <linux@zary.sk>
Subject: [RFC PATCH 0/4] fdomain: Resurrect driver (modular version)
Date: Mon, 22 Apr 2019 19:33:19 +0200
Message-ID: <20190422173323.15365-1-linux@zary.sk>
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

-- 
Ondrej Zary
