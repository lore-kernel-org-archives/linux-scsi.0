From: Brian King <brking@us.ibm.com>
Subject: [PATCH 0/6] ipr version 2.1.3
Date: Wed, 29 Mar 2006 09:37:01 -0600
Message-ID: <442AA99D.1040404@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33471 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751179AbWC2PhZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 10:37:25 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2TFbDIT008418
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:13 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2TFb2YX235020
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:02 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k2TFb2ZU018538
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

James,

The following patches update ipr to 2.1.3. The patches are changes
required in preparation for supporting attaching SATA devices to
ipr SAS adapters. This patchset is all the patches that do not
require libata changes.

Please apply.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
