From: Gabriel C <nix.or.die@googlemail.com>
Subject: drivers/scsi/advansys.c compile error ( Re: 2.6.23-rc1-mm2 )
Date: Wed, 01 Aug 2007 15:01:33 +0200
Message-ID: <46B0842D.3060703@googlemail.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:52335 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760800AbXHANBz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 09:01:55 -0400
Received: by nf-out-0910.google.com with SMTP id g13so53696nfb
        for <linux-scsi@vger.kernel.org>; Wed, 01 Aug 2007 06:01:54 -0700 (PDT)
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Getting this with a randconfig ( http://194.231.229.228/MM/randconfig-auto-10 )

...

drivers/scsi/advansys.c:794:2: warning: #warning this driver is still not properly converted to the DMA API
drivers/scsi/advansys.c: In function 'advansys_board_found':
drivers/scsi/advansys.c:17781: error: implicit declaration of function 'to_pci_dev'
drivers/scsi/advansys.c:17781: warning: pointer/integer type mismatch in conditional expression
drivers/scsi/advansys.c:17788: warning: unused variable 'pci_memory_address'
drivers/scsi/advansys.c:17781: warning: unused variable 'pdev'
make[2]: *** [drivers/scsi/advansys.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make[1]: *** Waiting for unfinished jobs....

...


