From: Doug Maxey <dwm@maxeymade.com>
Subject: [RFC] mode pages for ATA/ATAPI devices via libata
Date: Wed, 11 May 2005 13:01:25 -0500
Message-ID: <200505111801.j4BI1P5C019280@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:18864 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S261242AbVEKSCK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 14:02:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Doug Gilbert <dgilbert@interlog.com>, Albert CC Lee <albertcc@tw.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Howdy,

When a ATA/ATAPI device is attached via libata, what should the handling 
be for mode pages that do not exist in the device?

Assuming the page being asked for is 0x83, should libata fake up the
page from the IDENTIFY (PACKET) DEVICE data?  Or should it just respond
there is no page 0x83 as it does now in INQUIRY?  Likewise for 0x80?

++doug

