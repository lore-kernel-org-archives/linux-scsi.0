From: Edward Goggin <egoggin@vmware.com>
Subject: [PATCH 0/2] : definion, code, and use of new SCSI ML host status
	DID_COND_REQUEUE
Date: Fri, 02 Feb 2007 17:04:47 -0500
Message-ID: <1170453887.14264.73.camel@egoggin-devd.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.vmware.com ([65.113.40.130]:33036 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946111AbXBBWFJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 17:05:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, eric.moore@lsi.com

Patch Set Summary:

1	Define new SCSI ML host status DID_COND_REQUEUE and
	add its handling code to scsi_decide_disposition.
	Scsi_decide_disposition returns ADD_TO_MLQUEUE IFF
	not REQ_FAILFAST.

2	Return DID_COND_REQUEUE instead of DID_BUS_BUSY host status
	in MPT fusion driver when IOC status is SUCCESS and scsi
	status is busy.

Signed-off-by: Ed Goggin <egoggin@vmware.com>
