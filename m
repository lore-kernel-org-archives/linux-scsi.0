From: Jeff Garzik <jgarzik@pobox.com>
Subject: sleeping in scsi EH
Date: Thu, 26 May 2005 22:26:40 -0400
Message-ID: <42968560.7020608@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:28380 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261803AbVE0C0r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 22:26:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


What are the rules for sleeping (msleep, etc.) in the normal EH hooks?

         int (* eh_abort_handler)(struct scsi_cmnd *);
         int (* eh_device_reset_handler)(struct scsi_cmnd *);
         int (* eh_bus_reset_handler)(struct scsi_cmnd *);
         int (* eh_host_reset_handler)(struct scsi_cmnd *);

If I could sleep in these functions, then I could eliminate libata's use 
of ->eh_strategy_handler().

	Jeff



