From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bugme-new] [Bug 9405] New: iSCSI does not implement ordering
 guarantees required by e.g. journaling filesystems
Date: Mon, 19 Nov 2007 15:24:24 -0600
Message-ID: <4741FF08.7090103@cs.wisc.edu>
References: <bug-9405-10286@http.bugzilla.kernel.org/> <20071119125040.9f6eb1e2.akpm@linux-foundation.org> <4741FCEA.4040101@cs.wisc.edu> <20071119211854.GG12494@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020000000408040304090901"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54815 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbXKSVZc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 16:25:32 -0500
In-Reply-To: <20071119211854.GG12494@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, bart.vanassche@gmail.com

This is a multi-part message in MIME format.
--------------020000000408040304090901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Matthew Wilcox wrote:
> On Mon, Nov 19, 2007 at 03:15:22PM -0600, Mike Christie wrote:
>> +iSCSI
> 
> It's traditional to use all-caps here, even when the normal
> capitalisation is different.  so I think this should be "ISCSI".
> Damned if I know why we have this convention, though.
> 

Thanks. Here is a updated patch.

--------------020000000408040304090901
Content-Type: text/x-patch;
 name="add-mike-christie-to-maintainers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="add-mike-christie-to-maintainers.patch"

Add Mike Christie to MAINTAINERS file.

v2 - used all caps for system

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1c7c229..1fdbb72 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2111,6 +2111,14 @@ L:	irda-users@lists.sourceforge.net (subscribers-only)
 W:	http://irda.sourceforge.net/
 S:	Maintained
 
+ISCSI
+P:	Mike Christie
+M:	michaelc@cs.wisc.edu
+L:	open-iscsi@googlegroups.com
+W:	www.open-iscsi.org
+T:	git kernel.org:/pub/scm/linux/kernel/mnc/linux-2.6-iscsi.git
+S:	Maintained
+
 ISAPNP
 P:	Jaroslav Kysela
 M:	perex@perex.cz

--------------020000000408040304090901--
