From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 0/6] ibmvfc: fixes for 2.6.27-rc
Date: Fri, 15 Aug 2008 10:59:47 -0500
Message-ID: <48A5A7F3.1090100@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39807 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbYHOQAb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2008 12:00:31 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7FG0US5010031
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:30 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FG0UxV226768
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:30 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FG0TEk003826
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

James,

Here are a few small fixes for 2.6.27-rc.

* Fix another hang on module removal
* Fix an adapter state machine fix
* Fix for lost async events
* Sanitize sense data lengths to prevent buffer overruns
  in case of invalid data.
* Add additional data to async logs

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


