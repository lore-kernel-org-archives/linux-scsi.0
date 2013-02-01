From: Bart Van Assche <bvanassche@acm.org>
Subject: [LSF/MM TOPIC] Reducing the SRP initiator failover time
Date: Fri, 01 Feb 2013 14:43:38 +0100
Message-ID: <510BC68A.90708@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:44228 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3BANnm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2013 08:43:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, David Dillow <dillowda@ornl.gov>

It is known that it takes about two to three minutes before the upstream 
SRP initiator fails over from a failed path to a working path. This is 
not only considered longer than acceptable but is also longer than other 
Linux SCSI initiators (e.g. iSCSI and FC). Progress so far with 
improving the fail-over SRP initiator has been slow. This is because the 
discussion about candidate patches occurred at two different levels: not 
only the patches itself were discussed but also the approach that should 
be followed. That last aspect is easier to discuss in a meeting than 
over a mailing list. Hence the proposal to discuss SRP initiator 
failover behavior during the LSF/MM summit. The topics that need further 
discussion are:
* If a path fails, remove the entire SCSI host or preserve the SCSI
   host and only remove the SCSI devices associated with that host ?
* Which software component should test the state of a path and should
   reconnect to an SRP target if a path is restored ? Should that be
   done by the user space process srp_daemon or by the SRP initiator
   kernel module ?
* How should the SRP initiator behave after a path failure has been
   detected ? Should the behavior be similar to the FC initiator with
   its fast_io_fail_tmo and dev_loss_tmo parameters ?

Dave, if this topic gets accepted, I really hope you will be able to 
attend the LSF/MM summit.

Bart.
