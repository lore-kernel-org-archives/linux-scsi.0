From: Douglas Gilbert <dougg@torque.net>
Subject: Re: GFDL issue in Documentation/DocBook/scsidrivers.tmpl
Date: Mon, 11 Aug 2003 21:54:48 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F378408.9090708@torque.net>
References: <20030807162521.GA30904@lst.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010605040407030805020809"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:38113 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S272529AbTHKL4D
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 07:56:03 -0400
In-Reply-To: <20030807162521.GA30904@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010605040407030805020809
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Christoph Hellwig wrote:
> As discussed in the thread at
> http://www.ussg.iu.edu/hypermail/linux/kernel/0306.1/1928.html
> we agreed that GFDL is not an acceptable license for documentation
> in the kernel tree, but file in subject still comes under that
> license.
> 
> Douglas, any chance you could relicense it under something
> GPL-compatible?  It probably wants folding into scsi_mid_low_api.txt
> anyway..

Is the attached preferable?
[Switch GFDL to GPL]

Doug Gilbert


--------------010605040407030805020809
Content-Type: text/plain;
 name="scsidriver_doc.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsidriver_doc.diff"

--- linux/Documentation/DocBook/scsidrivers.tmpl	2003-01-09 22:09:24.000000000 +1000
+++ linux/Documentation/DocBook/scsidrivers.tmpl260t3gpl	2003-08-11 08:50:09.000000000 +1000
@@ -16,20 +16,40 @@
     </affiliation>
    </author>
   </authorgroup>
-  <pubdate>2002-04-27</pubdate>
+  <pubdate>2003-08-11</pubdate>
 
   <copyright>
    <year>2002</year>
+   <year>2003</year>
    <holder>Douglas Gilbert</holder>
   </copyright>
+
   <legalnotice>
    <para>
-    Permission is granted to copy, distribute and/or modify this
-    document under the terms of the GNU Free Documentation License,
-    Version 1.1 or any later version published by the Free Software
-    Foundation; with no Invariant Sections, with no Front-Cover Texts,
-    and with no Back-Cover Texts.  A copy of the license is included
-    in the section entitled "GNU Free Documentation License".
+     This documentation is free software; you can redistribute
+     it and/or modify it under the terms of the GNU General Public
+     License as published by the Free Software Foundation; either
+     version 2 of the License, or (at your option) any later
+     version.
+   </para>
+      
+   <para>
+     This program is distributed in the hope that it will be
+     useful, but WITHOUT ANY WARRANTY; without even the implied
+     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+     See the GNU General Public License for more details.
+   </para>
+      
+   <para>
+     You should have received a copy of the GNU General Public
+     License along with this program; if not, write to the Free
+     Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+     MA 02111-1307 USA
+   </para>
+      
+   <para>
+     For more details see the file COPYING in the source
+     distribution of Linux.
    </para>
   </legalnotice>
 

--------------010605040407030805020809--

