From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/2] scsi tgt: ibmvstgt driver and libsrp
Date: Sat, 29 Apr 2006 15:59:16 +0900 (JST)
Message-ID: <20060429155903F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:31456 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1750838AbWD2G7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Apr 2006 02:59:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

The following patchset addes IBM Virtual SCSI target driver for tgt.

There's a fair chance that we'll get several SRP target drivers (for
IBM Power5 and OpenIB at least). They will have lots of duplicated
code. libsrp tries to provide helper functions for them to avoid that.
It enables each SRP target driver to focus on their own low-level
transport stuff.
