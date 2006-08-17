From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [RFC][PATCH 67/75] scsi: drivers/scsi/tmscsim.c pci_module_init to pci_register_driver conversion
Date: Thu, 17 Aug 2006 13:29:41 +0000
Message-ID: <20060817132941.67.ZRpalO5377.3636.michal@euridica.enternet.net.pl>
References: <20060817132638.0.iSIzDm3640.3636.michal@euridica.enternet.net.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964955AbWHQNbX@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060817132638.0.iSIzDm3640.3636.michal@euridica.enternet.net.pl>  
Sender: linux-kernel-owner@vger.kernel.org
To: kurt@garloff.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

diff -uprN -X linux-work/Documentation/dontdiff linux-work-clean/drivers/scsi/tmscsim.c linux-work2/drivers/scsi/tmscsim.c
--- linux-work-clean/drivers/scsi/tmscsim.c	2006-08-16 22:41:01.000000000 +0200
+++ linux-work2/drivers/scsi/tmscsim.c	2006-08-17 05:21:14.000000000 +0200
@@ -2670,7 +2670,7 @@ static int __init dc390_module_init(void
 		printk (KERN_INFO "DC390: Using safe settings.\n");
 	}
 
-	return pci_module_init(&dc390_driver);
+	return pci_register_driver(&dc390_driver);
 }
 
 static void __exit dc390_module_exit(void)
