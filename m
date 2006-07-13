From: Brian King <brking@us.ibm.com>
Subject: PCI ID table in DAC960
Date: Thu, 13 Jul 2006 14:37:10 -0500
Message-ID: <44B6A0E6.90500@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47283 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1030326AbWGMThM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 15:37:12 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6DJbBuZ001019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2006 15:37:12 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6DJbBWG285076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2006 15:37:11 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6DJbBbN002552
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2006 15:37:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

Christoph,

You added support for the "GEM series" of DAC960 controllers
sometime last year. These controllers use the same PCI chip
as some ipr adapters. The pci id table that got added to DAC960
was:

 .vendor = PCI_VENDOR_ID_MYLEX,
 .device = PCI_DEVICE_ID_MYLEX_DAC960_GEM,
 .subvendor = PCI_ANY_ID,
 .subdevice = PCI_ANY_ID,

which collides with several ipr adapters.
The chip is a common chip that was used by both Mylex and IBM.
Do you, or anyone else on this list, have the list of subvendor/subdevice
entries for this adapter so we could update the pci id table appropriately? 


Thanks,

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
