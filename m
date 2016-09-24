From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 0/3] g_NCR5380: Modernization
Date: Sat, 24 Sep 2016 20:59:02 +0200
Message-ID: <1474743545-4731-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


This small patch series removes deprecated code from g_NCR5380 driver
and converts it from scsi_module.c to scsi_add_host().

Tested with:
HP C2502 (53C400A chip)
Canon FG2-5202 (53C400 chip, memory-mapped)
DTC-3181L (DTCT-436P chip, PnP)

P.S. I don't like the ifdef mess needed for g_NCR5380_mmio. Should I try to
merge the code so g_NCR5380 will support both PIO and MMIO cards (and
g_NCR5380_mmio could be removed)?

-- 
Ondrej Zary
