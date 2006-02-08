From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 19/22] lpfc 8.1.2 : Fixed module parameter descriptions
Date: Wed, 08 Feb 2006 10:43:17 -0500
Message-ID: <43EA1195.7080706@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55181 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030515AbWBHPnU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:43:20 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18FhJrf011945
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:43:19 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Fixed module parameter descriptions.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -664,10 +664,10 @@ LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0
  # is 0. Default value of cr_count is 1. The cr_count feature is disabled if
  # cr_delay is set to 0.
  */
-LPFC_ATTR_RW(cr_delay, 0, 0, 63, "A count of milliseconds after which an"
+LPFC_ATTR_RW(cr_delay, 0, 0, 63, "A count of milliseconds after which an "
  		"interrupt response is generated");

-LPFC_ATTR_RW(cr_count, 1, 1, 255, "A count of I/O completions after which an"
+LPFC_ATTR_RW(cr_count, 1, 1, 255, "A count of I/O completions after which an "
  		"interrupt response is generated");

  /*
@@ -683,7 +683,7 @@ LPFC_ATTR_RW(fdmi_on, 0, 0, 2, "Enable F
  # Specifies the maximum number of ELS cmds we can have outstanding (for
  # discovery). Value range is [1,64]. Default value = 32.
  */
-LPFC_ATTR(discovery_threads, 32, 1, 64, "Maximum number of ELS commands"
+LPFC_ATTR(discovery_threads, 32, 1, 64, "Maximum number of ELS commands "
  		 "during discovery");

  /*

