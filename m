From: Douglas Gilbert <dougg@torque.net>
Subject: hdparm 7.3 supports SAT
Date: Thu, 10 May 2007 17:55:32 -0400
Message-ID: <464394D4.10503@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42945 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbXEJV65 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 17:58:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mlord@pobox.com

Mark Lord's hdparm version 7.3 supports the SCSI to ATA
Translation (SAT) pass-through. So if SAT is supported,
this allows hdparm to access ATA (e.g. SATA disks) and
ATAPI (e.g. cd/dvd drives) devices behind SCSI transports.

Note that the SAT layer may be in the kernel (e.g. libata),
in a HBA's firmware (MPT Fusion SAS HBAs) or external.
Also one of those "SCSI transports" might be SATA.

See http://sourceforge.net/projects/hdparm/


Both sdparm and two utilities in sg3_utils used some
tortured syntax to pipe through ATA IDENTIFY (PACKET)
DEVICE responses to 'hdparm --Istdin' prior to hdparm 7.x .
That, in most cases, should no longer be needed.

Doug Gilbert
