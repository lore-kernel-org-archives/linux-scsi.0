From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 2/23]: SCST core
Date: Wed, 10 Dec 2008 21:30:37 +0300
Message-ID: <49400ACD.3070502@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756063AbYLJSeG@vger.kernel.org>
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

This patch contains SCST core code.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/Kconfig         |  256 ++
  drivers/scst/Makefile        |   12
  drivers/scst/scst_cdbprobe.h |  519 +++++
  drivers/scst/scst_lib.c      | 3689 +++++++++++++++++++++++++++++++++++++
  drivers/scst/scst_main.c     | 1919 +++++++++++++++++++
  drivers/scst/scst_module.c   |   69
  drivers/scst/scst_priv.h     |  513 +++++
  drivers/scst/scst_targ.c     | 5458 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  8 files changed, 12435 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/scst_core.diff
