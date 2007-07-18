From: Christian Hesse <mail@earthworm.de>
Subject: typo in linux/Documentation/scsi/aic7xxx.txt
Date: Wed, 18 Jul 2007 17:29:48 +0200
Message-ID: <200707181729.54710.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yHjnGGHbovyED7M"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kolab.mylinuxtime.de ([212.112.242.22]:40360 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759841AbXGRP70 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 11:59:26 -0400
Received: from localhost (ip2 [127.0.0.1])
	by kolab.mylinuxtime.de (Postfix) with ESMTP id EA1AF7C0CA3
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 17:25:08 +0200 (CEST)
Received: from kolab.mylinuxtime.de ([127.0.0.1])
 by localhost (kolab.mylinuxtime.de [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 19787-08 for <linux-scsi@vger.kernel.org>;
 Wed, 18 Jul 2007 17:25:08 +0200 (CEST)
Received: from localhost (ip2 [127.0.0.1])
	by kolab.mylinuxtime.de (Postfix) with ESMTP id C3B9D7C0D81
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 17:25:08 +0200 (CEST)
Received: from localhost (unknown [10.5.1.205])
	by kolab.mylinuxtime.de (Postfix) with ESMTP id B0EE77C0CA3
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 17:25:08 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--Boundary-00=_yHjnGGHbovyED7M
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello everybody,

I think I found a typo in linux/Documentation/scsi/aic7xxx.txt. Patch is 
attached.

Signed-off-by: Christian Hesse <mail@earthworm.de>
-- 
Regards,
Chris

--Boundary-00=_yHjnGGHbovyED7M
Content-Type: text/x-diff;
  charset="utf-8";
  name="typo.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="typo.diff"

--- linux/Documentation/scsi/aic7xxx.txt	2007-07-09 10:54:39.000000000 +0200
+++ linux/Documentation/scsi/aic7xxx.txt	2007-07-18 17:22:37.425400931 +0200
@@ -256,7 +256,7 @@ The following information is available i
               Option: global_tag_depth:[value]
           Definition: Global tag depth for all targets on all busses.
                       This option sets the default tag depth which
-                      may be selectively overridden vi the tag_info
+                      may be selectively overridden via the tag_info
                       option.
      Possible Values: 1 - 253
        Default Value: 32

--Boundary-00=_yHjnGGHbovyED7M--
