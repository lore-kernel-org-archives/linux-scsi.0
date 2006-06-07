From: Brian King <brking@us.ibm.com>
Subject: [PATCH 0/6] libata: Support SATA attached via SAS
Date: Wed, 07 Jun 2006 11:24:29 -0500
Message-ID: <4486FDBD.9030200@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56297 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932294AbWFGQYk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2006 12:24:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

Jeff,

Here is a refresh of my patchset to allow SAS HBAs to use libata to
control attached SATA devices. It should apply cleanly to #upstream.

James,

After our discussion at the storage summit I think I have
a better idea what you are looking for with a SATA transport class.
Unfortunately, the problem I am facing is that I am dealing with a
firmware stack (ipr) which does not expose the physical transport
to the host. The ipr firmware does all the device discovery and reports
a configuration table describing the attached devices, but does not
export any physical topology information. At some point in the future
I hope to be able to extract this information from the ipr firmware
stack and convert ipr to be able to utilize the sas/sata transport class,
but, unfortunately, the firmware interfaces to accomplish this
aren't available at this time.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
