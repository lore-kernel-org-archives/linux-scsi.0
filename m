From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] convert struct scsi_varlen_cdb_hdr in scsi.h to use __u8 for user space
Date: Sun, 29 Jun 2008 06:43:46 -0600
Message-ID: <20080629124346.GJ14894@parisc-linux.org>
References: <20080629210323W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53614 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbYF2MoE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2008 08:44:04 -0400
Content-Disposition: inline
In-Reply-To: <20080629210323W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org


But we don't install anything in include/scsi to userspace:

$ cat include/Kbuild 
header-y += asm-generic/
header-y += linux/
header-y += sound/
header-y += mtd/
header-y += rdma/
header-y += video/

header-y += asm-$(ARCH)/

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
