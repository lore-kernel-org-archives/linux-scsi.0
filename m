From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/2] iscsi_transport: misc changes
Date: Thu, 22 Jul 2010 16:54:41 +0530 (IST)
Message-ID: <alpine.OSX.1.00.1007221649540.1395@Vikas.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:4898
	"HELO Vikas.local" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with SMTP id S1755554Ab0GVLYr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2010 07:24:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com


James,

Please apply following iscsi transport patches to scsi-misc-2.6 tree
these patches are on top of iscsi transport patch posted in our previous
patch set. (http://marc.info/?l=linux-scsi&m=127875362624209&w=2)

Vikas Chaudhary (1)
0001-iscsi_transport-Modidify-recovery_tmo-from-sysfs.patch

Mike Christie (1)
0002-iscsi_transport-wait-on-session-in-error-handler-pat.patch

drivers/scsi/qla4xxx/ql4_os.c       |   11 +++++-
drivers/scsi/scsi_transport_iscsi.c |   75 ++++++++++++++++++++++++++++++++--
include/scsi/scsi_transport_iscsi.h |    2 +


Thanks,
Vikas.
