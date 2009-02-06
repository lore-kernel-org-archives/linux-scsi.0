From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] kernel-doc: preferred ending marker and examples
Date: Fri, 06 Feb 2009 11:26:29 -0800
Message-ID: <498C8EE5.2030002@oracle.com>
References: <20081209231005.17830.92133.stgit@fritz>	<20081209231024.17830.97893.stgit@fritz>	<20090204182441.4a8def70.akpm@linux-foundation.org>	<1233947117.7785.5.camel@fritz> <20090206111301.67ddac2d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:27813 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbZBFT2M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2009 14:28:12 -0500
In-Reply-To: <20090206111301.67ddac2d.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Love <robert.w.love@intel.com>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jgarzik@redhat.com, davem@davemloft.net, james.smart@emulex.com, michaelc@cs.wisc.edu, jeykholt@cisco.com, andi@firstfloor.org, jeffrey.t.kirsher@intel.com

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc-nano-HOWTO.txt to use */ as the ending marker in
kernel-doc examples and state that */ is the preferred ending marker.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-doc-nano-HOWTO.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-next-20090206.orig/Documentation/kernel-doc-nano-HOWTO.txt
+++ linux-next-20090206/Documentation/kernel-doc-nano-HOWTO.txt
@@ -43,7 +43,8 @@ Only comments so marked will be consider
 and any comment so marked must be in kernel-doc format.  Do not use
 "/**" to be begin a comment block unless the comment block contains
 kernel-doc formatted comments.  The closing comment marker for
-kernel-doc comments can be either "*/" or "**/".
+kernel-doc comments can be either "*/" or "**/", but "*/" is
+preferred in the Linux kernel tree.
 
 Kernel-doc comments should be placed just before the function
 or data structure being described.
@@ -63,7 +64,7 @@ Example kernel-doc function comment:
  * comment lines.
  *
  * The longer description can have multiple paragraphs.
- **/
+ */
 
 The first line, with the short description, must be on a single line.
 
@@ -85,7 +86,7 @@ Example kernel-doc data structure commen
  *		perhaps with more lines and words.
  *
  * Longer description of this structure.
- **/
+ */
 
 The kernel-doc function comments describe each parameter to the
 function, in order, with the @name lines.
