From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Help - a question on scsi_debug and mid-layer
Date: 21 Jun 2004 14:12:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087845161.2077.75.camel@mulgrave>
References: <519672568F040C41B6FAC21ADF51B18FF03D@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:59565 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266419AbUFUTMr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 15:12:47 -0400
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FF03D@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Douglas Gilbert <dougg@torque.net>

On Mon, 2004-06-21 at 13:53, Lee Xing wrote:
> I'm playing with scsi_debug (a low-level driver) of lk2.4 and notice that scsi_debug_queuecommand(...) defined in scsi_debug returns sometimes before the SCSI command completes (i.e. before done(cmd) is invoked), and sometimes after done(cmd) is invoked.  Can SCSI mid-layer really handle both cases without any problems, and why?
> 
> I assume that before scsi_debug_queuecommand() returns the control to mid-layer, mid-layer has no way to know whether that SCSI command has been successfully queued in low-level driver, therefore scsi_debug should not invoke done(cmd) before completing scsi_debug_queuecommand(...), correct?

I think if you look in Documentation/scsi/scsi_mid_low_api.txt (on 2.6)
you'll find it explains all of this under the entry for queuecommand.

James


