From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: [RFC][PATCH] megaraid 2.00rc5 as 'megaraid2' for kernel 2.5.x
Date: Wed, 9 Oct 2002 16:58:46 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210091649180.8828-100000@tux.us.dell.com>
References: <20BF5713E14D5B48AA289F72BD372D68BC0257@AUSXMPC122.aus.amer.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20BF5713E14D5B48AA289F72BD372D68BC0257@AUSXMPC122.aus.amer.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

(resend without patch attached - it's 170K and didn't seem to make it through)

Posted to
  http://domsch.com/linux/megaraid/linux-2.5-megaraid-2.00rc5.patch
  http://domsch.com/linux/megaraid/linux-2.5-megaraid-2.00rc5.patch.asc

is a patch to create 'megaraid2', the megaraid 2.00rc5 driver which
includes fixups such that it works on kernel 2.5.41.   The v2.00 
has significant code path cleanups (easier to read and maintain),
support for SCSI reservations (needed for shared storage clustering),
and will soon have an improved higher performance interface to card
firmware.  This driver is being developed by LSI, with assistance from
Red Hat and Dell.

By providing this as a megaraid2 driver, it allows development to
continue on it separate from the stable megaraid (based on 1.18)
driver already present in the 2.5.41 kernel.  This driver works at
least somewhat for me, with slighly increased performance over the
1.18-based driver.  It still likely has bugs related to being 
ported to 2.5.x.  Mike Anderson has already caught one such bug - (use
page_address(page)+offset) - fixed internally.

 MAINTAINERS              |    8 
 arch/i386/defconfig      |    1 
 drivers/scsi/Config.help |   11 
 drivers/scsi/Config.in   |    3 
 drivers/scsi/Makefile    |    3 
 drivers/scsi/megaraid2.c | 5611 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/megaraid2.h | 1175 +++++++++
 7 files changed, 6809 insertions, 3 deletions

If there are no objections, I'll submit this to Linus and Dave Jones 
later this week for inclusion.  This has been posted to 
linux-megaraid-devel@dell.com as well.

Thanks,
Matt

--
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

