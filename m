From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] 2.5.22 drivers_scsi_ips.c cleanup
Date: Mon, 15 Jul 2002 18:16:30 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020715082114.D834242E8@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org

From: (via Rusty) rwhron@earthlink.net

  Chris,
  
  Thanks for posting the patch.  It's needed in 2.5.22.
  Rusty's patch system works well.  Patch message 
  reproduced below.
  
  The IBM ServeRAID driver does not compile in recent 2.5 kernels.  The
  simple patch below fixes the compilation error and has been tested at OSDL.
  
  thanks,
  -chris
  

--- trivial-2.5.25/drivers/scsi/ips.c.orig	Mon Jul 15 17:03:25 2002
+++ trivial-2.5.25/drivers/scsi/ips.c	Mon Jul 15 17:03:25 2002
@@ -596,7 +596,7 @@
    }
 
    return (1);
-
+}
 __setup("ips=", ips_setup);
 
 #else
@@ -633,9 +633,9 @@
       }
    }
 
+}
 #endif
 
-}
 
 /****************************************************************************/
 /*                                                                          */
-- 
  Don't blame me: the Monkey is driving
