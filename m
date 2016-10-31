From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 0/6] (g_)NCR5380: Improve IRQ probing and some fixes
Date: Mon, 31 Oct 2016 21:18:26 +0100
Message-ID: <1477945112-25659-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,
this patch series improves IRQ probing and moves it from NCR5380 to
g_NCR5380, adds IRQ auto-configuration for HP C2502 and enables all
this by default. It also adds IRQ and base address checks to prevent
hangs when wrong values are specified by user. There's also a small
release region fix in error handling.
