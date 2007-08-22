From: Gabriel C <nix.or.die@googlemail.com>
Subject: drivers/scsi/advansys.c - ld error ( Re: 2.6.23-rc3-mm1 )
Date: Wed, 22 Aug 2007 18:15:14 +0200
Message-ID: <46CC6112.9030705@googlemail.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:12127 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758224AbXHVQQh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Aug 2007 12:16:37 -0400
Received: by nf-out-0910.google.com with SMTP id g13so158027nfb
        for <linux-scsi@vger.kernel.org>; Wed, 22 Aug 2007 09:16:35 -0700 (PDT)
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

CONFIG_SCSI_ADVANSYS=y && CONFIG_ISA=n results in :

...

drivers/built-in.o: In function `advansys_init':
advansys.c:(.init.text+0x38ea): undefined reference to `isa_register_driver'
advansys.c:(.init.text+0x38ff): undefined reference to `isa_register_driver'
advansys.c:(.init.text+0x3926): undefined reference to `isa_unregister_driver'
advansys.c:(.init.text+0x3930): undefined reference to `isa_unregister_driver'
drivers/built-in.o: In function `advansys_exit':
advansys.c:(.exit.text+0x340): undefined reference to `isa_unregister_driver'
advansys.c:(.exit.text+0x34a): undefined reference to `isa_unregister_driver'
make: *** [.tmp_vmlinux1] Error 1

...


I guess advansys_{init,exit} is missing some #ifdef's ..


config : http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/r/randconfig-9


Gabriel

