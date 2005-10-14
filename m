From: "Kolli, Neela Syam" <Neela.Kolli@engenio.com>
Subject: RE: [Bugme-new] [Bug 5440] New: Perc4 megaraid: module doesn't de
	tect cache memory and writeback mode
Date: Fri, 14 Oct 2005 17:23:58 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5707232011@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62602 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750790AbVJNVYL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 17:24:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, bugme-daemon@kernel-bugs.osdl.org

>(Could we pleeeeze have a megaraid entry in the MAINTAINERS file?)

Hi Andrew,
I am taking over all Megaraid SCSI drivers.  Here is the new patch for
MAINTENERS file.  This will apply against 2.6.14-rc4.
Thanks,
Neela Syam Kolli.

Signed-off-by: Neela Syam Kolli <Neela.Kolli@engenio.com>

diff -Naur 2.6.14-rc4-old/MAINTAINERS 2.6.14-rc4-new/MAINTAINERS
--- 2.6.14-rc4-old/MAINTAINERS  2005-10-14 18:12:08.355382552 -0400
+++ 2.6.14-rc4-new/MAINTAINERS  2005-10-14 18:15:40.512129824 -0400
@@ -1618,6 +1618,13 @@
 L:     linux-fbdev-devel@lists.sourceforge.net
 S:     Maintained
 
+MEGARAID SCSI DRIVERS
+P:     Neela Syam Kolli
+M:     Neela.Kolli@engenio.com
+S:     linux-scsi@vger.kernel.org
+W:     http://megaraid.lsilogic.com
+S:     Maintained
+
 MEMORY TECHNOLOGY DEVICES
 P:     David Woodhouse
 M:     dwmw2@infradead.org



