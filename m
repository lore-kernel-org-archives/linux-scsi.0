From: "Lee Xing" <lxing@Crossroads.com>
Subject: Help - a question on scsi_debug and mid-layer
Date: Mon, 21 Jun 2004 13:53:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FF03D@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:60132 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S264154AbUFUSxc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:53:32 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dougg@torque.net>

Hi,

I'm playing with scsi_debug (a low-level driver) of lk2.4 and notice that scsi_debug_queuecommand(...) defined in scsi_debug returns sometimes before the SCSI command completes (i.e. before done(cmd) is invoked), and sometimes after done(cmd) is invoked.  Can SCSI mid-layer really handle both cases without any problems, and why?

I assume that before scsi_debug_queuecommand() returns the control to mid-layer, mid-layer has no way to know whether that SCSI command has been successfully queued in low-level driver, therefore scsi_debug should not invoke done(cmd) before completing scsi_debug_queuecommand(...), correct?

Thanks,


T.

Lee Xing
Crossroads Systems, Inc.
(512) 928-7297


