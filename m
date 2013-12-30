From: Randy Dunlap <rdunlap@infradead.org>
Subject: scsi_transport_srp.c kernel-doc warnings
Date: Sun, 29 Dec 2013 21:02:57 -0800
Message-ID: <52C0FE81.4080209@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55961 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3L3FDB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Dec 2013 00:03:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Bart,

Please complete the kernel-doc notation in scsi_transport_srp.c to eliminate
the following kernel-doc warnings or make them not use kernel-doc notation
at all. [This list is from v3.13-rc6.]


Warning(drivers/scsi/scsi_transport_srp.c:75): No description found for parameter 'reconnect_delay'
Warning(drivers/scsi/scsi_transport_srp.c:75): No description found for parameter 'fast_io_fail_tmo'
Warning(drivers/scsi/scsi_transport_srp.c:75): No description found for parameter 'dev_loss_tmo'
Warning(drivers/scsi/scsi_transport_srp.c:373): No description found for parameter 'work'
Warning(drivers/scsi/scsi_transport_srp.c:413): No description found for parameter 'work'
Warning(drivers/scsi/scsi_transport_srp.c:431): No description found for parameter 'work'
Warning(drivers/scsi/scsi_transport_srp.c:496): No description found for parameter 'rport'
Warning(drivers/scsi/scsi_transport_srp.c:507): No description found for parameter 'shost'
Warning(drivers/scsi/scsi_transport_srp.c:545): No description found for parameter 'rport'
Warning(drivers/scsi/scsi_transport_srp.c:611): No description found for parameter 'scmd'
Warning(drivers/scsi/scsi_transport_srp.c:679): No description found for parameter 'rport'
Warning(drivers/scsi/scsi_transport_srp.c:688): No description found for parameter 'rport'


thanks,
-- 
~Randy
