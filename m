From: Brian King <brking@us.ibm.com>
Subject: [PATCH 0/2] scsi: Add max_cmd_len to struct scsi_device
Date: Tue, 28 Mar 2006 16:17:12 -0600
Message-ID: <4429B5E8.6060204@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:63929 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932444AbWC1WRf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 17:17:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James.Bottomley@steeleye.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

James/Jeff,

The following 2 patches add a max_cmd_len field to the scsi_device
struct. This is in response the the thread that resulted from
one of my SAS/SATA patches:

http://marc.theaimsgroup.com/?l=linux-scsi&m=114263742004656&w=2

Please apply.

Thanks,

Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
