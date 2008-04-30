From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: [PATCH] aacraid: Fix warning about macro side-effects
Date: Wed, 30 Apr 2008 15:28:32 -0400
Message-ID: <1E278B55-6C77-42FA-8B15-16A0939203FB@adaptec.com>
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com> <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com> <86802c440804211742g1fe25aadjeaffce49722e7c46@mail.gmail.com> <BCC76E6D-9A0F-4DC1-822A-50EE44A52890@adaptec.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-33--651721118
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:48328 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763685AbYD3T2e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2008 15:28:34 -0400
Received: from Macintosh.adaptec.com (unknown [10.5.3.1])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 927AD24C8A3
	for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2008 12:28:33 -0700 (PDT)
In-Reply-To: <BCC76E6D-9A0F-4DC1-822A-50EE44A52890@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-Scsi <linux-scsi@vger.kernel.org>


--Apple-Mail-33--651721118
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

On some compile environments, warnings are produced regarding the  
usage of aac_logical_to_phys macro.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's  
handling of patch attachments (inline gets damaged, please use  
attachment).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

  drivers/scsi/aacraid/aacraid.h |    4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff -ru a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/ 
aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h	2008-04-30 15:17:53.770782679 -0400
+++ b/drivers/scsi/aacraid/aacraid.h	2008-04-30 15:22:14.338590856 -0400
@@ -34,8 +34,8 @@
  #define CONTAINER_TO_ID(cont)		(cont)
  #define CONTAINER_TO_LUN(cont)		(0)

-#define aac_phys_to_logical(x)  (x+1)
-#define aac_logical_to_phys(x)  (x?x-1:0)
+#define aac_phys_to_logical(x)  ((x)+1)
+#define aac_logical_to_phys(x)  ((x)?(x)-1:0)

  /* #define AAC_DETAILED_STATUS_INFO */


Sincerely - Mark Salyzyn

--Apple-Mail-33--651721118
Content-Disposition: attachment;
	filename=aacraid_side_effects.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="aacraid_side_effects.patch"
Content-Transfer-Encoding: 7bit

diff -ru a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h	2008-04-30 15:17:53.770782679 -0400
+++ b/drivers/scsi/aacraid/aacraid.h	2008-04-30 15:22:14.338590856 -0400
@@ -34,8 +34,8 @@
 #define CONTAINER_TO_ID(cont)		(cont)
 #define CONTAINER_TO_LUN(cont)		(0)
 
-#define aac_phys_to_logical(x)  (x+1)
-#define aac_logical_to_phys(x)  (x?x-1:0)
+#define aac_phys_to_logical(x)  ((x)+1)
+#define aac_logical_to_phys(x)  ((x)?(x)-1:0)
 
 /* #define AAC_DETAILED_STATUS_INFO */
 

--Apple-Mail-33--651721118
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



--Apple-Mail-33--651721118--
