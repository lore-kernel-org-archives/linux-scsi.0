From: Thomas Witzel <witzel.thomas@gmail.com>
Subject: DELL Universal Xport no attach blacklist
Date: Sat, 13 Jun 2009 10:11:08 -0400
Message-ID: <d1392840906130711o7a1cba14k2b5379511c700817@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:44515 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbZFMOLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Jun 2009 10:11:07 -0400
Received: by ewy6 with SMTP id 6so3757460ewy.37
        for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2009 07:11:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have been getting tons of Buffer I/O errors on the Universal Xport
devices of my DELL MD3000. This can be managed by not attaching
them....
Can you please add the DELL Universal Xport to the no attach list in
scsi_devinfo.c ? I'm not sure how to submit a patch because I don't
know which version of the kernel the patch should be against, but I
know its not yet in the newest Linus kernel. I want this line added
please,

--- scsi-git/scsi_devinfo.c     2009-03-31 10:54:00.000000000 -0400
+++ scsi/scsi_devinfo.c 2009-06-13 10:08:46.000000000 -0400
@@ -225,6 +225,7 @@
        {"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
        {"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
        {"SUN", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+       {"DELL", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
        {"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
        {"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
        {"SONY", "TSL", NULL, BLIST_FORCELUN},          /* DDS3 & DDS4
autoloaders */

Thank you,
Thomas Witzel
