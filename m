From: Krishna Murthy <krmurthy@cisco.com>
Subject: scsi_free_sdev and slave destroy
Date: Tue, 25 Nov 2003 20:37:34 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311252037.34015.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:34357 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S262707AbTKYPIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2003 10:08:51 -0500
Received: from krmurthy1-lnx.cisco.com (krmurthy1-lnx.cisco.com [10.77.7.60])
	by india-msg-core-1.cisco.com (8.12.9/8.12.6) with ESMTP id hAPKaM0s016708
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 20:36:23 GMT
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: davmyers@cisco.com

Hi,
	I was going through the function 
scsi_probe_and_add_lun().
It does 
		scsi_alloc_sdev
		probe for the lun
		If lun does not exist call scsi_free_sdev.

scsi_alloc_sdev calls slave_alloc of the HBA driver where as 
scsi_free_sdev does not seem to call slave_destroy.
Please let me know if this is a bug or I am missing something.

Thanx
N.C.Krishna Murthy



			
