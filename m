From: James.Smart@Emulex.Com
Subject: RE: [PATCH] [Update #2] suspending I/Os to a device
Date: Fri, 1 Oct 2004 12:15:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C086626@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:13242 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264531AbUJAQQI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 12:16:08 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, hch@infradead.org, andmike@us.ibm.com, mort@wildopensource.com, andrew.vasquez@qlogic.com

The difference is, the fc functions:
- Changes the actual sdev state to indicate a "blocked" state  (you can see it in sysfs, etc)
- Starts a timer that will automatically unblock the sdev w/o lld intervention

-- james

> What is the difference between these new fc_host_block/unblock and
> the current scsi_block/unblock_requests?
