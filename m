From: Michael Clark <michael@metaparadigm.com>
Subject: ANNOUNCE: saftemon - SCSI Enclosure monitor for linux
Date: Wed, 17 Apr 2002 19:01:10 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CBD55F6.10401@metaparadigm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from metaparadigm.com (mcns198.docsis241.scvmaxonline.com.sg [202.156.241.198])
	by gort.metaparadigm.com (Postfix) with ESMTP id 4A03214400E
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2002 19:01:12 +0800 (SGT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

saftemon - SCSI Enclosure monitor for SAFTE enclosures

   http://gort.metaparadigm.com/saftemon/

saftemon reads disk enclosure status information from SAF-TE
capable enclosures (SCSI Accessible Fault Tolerant Enclosures).
SAF-TE is a component of SES (SCSI Enclosure Services) which
is common on most SCSI disk enclosures these days. saftemon
can monitor multiple SAF-TE devices and will automatically probe
and detect them.

The information retreived includes power supply and fan status,
temperature, audible alarm, drive faults, array critical /
failed / rebuilding state and door lock status. saftemon logs
changes in the status of these enclosure elements to syslog and
can optionally execute an alert help program with details of the
component failure. This could send a pager message for example.
Temperate alert limits also be set.

saftemon is specifcally useful if you have equipment deployed in
remote locations or unattended over weekends when no-one may hear
an audible alarm.

It also includes an embedded web server for web status display
of enclosure information.

This is the initial public release so i'd be keen to receive any
feedback or compatibility testing. It has currently only been
tested on nStor external enclosures and Intel internal SAFTE
capable enclosures.

~mc


