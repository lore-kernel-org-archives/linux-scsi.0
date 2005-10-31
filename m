From: Jeff Garzik <jgarzik@pobox.com>
Subject: sas repo updated
Date: Mon, 31 Oct 2005 03:24:38 -0500
Message-ID: <4365D4C6.5030909@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:21901 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932070AbVJaIYq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 03:24:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

I updated my sas-2.6 repo to contain the following aic94xx+SAS goodies:

* scsi_host_template in LLDD, where it belongs
* use scsi_scan_target() rather than scsi_add_device()
	- uses standard scsi REPORT LUNS discovery code from there...
	- contains some #if 0 code, but that's temporary
* does NOT YET use scsi_transport_sas module

And some maintenance notes:

* branch 'master' now contains vanilla Linus tree
* branch 'scsi-misc' now contains James Bottomley's scsi-misc-2.6 tree
* branch 'upstream' now contains my aic94xx/SAS work

The above is all filtering out to mirrors now, at
rsync://rsync.kernel.org/pub/scm/linux/kernel/git/jgarzik/sas-2.6.git

Give the mirrors at least an hour to catch up.

	Jeff



