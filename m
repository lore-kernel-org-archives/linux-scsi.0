From: Douglas Gilbert <dougg@torque.net>
Subject: [RFC] SCSI Enclosure Services (SES) simulator
Date: Tue, 15 Feb 2005 22:34:11 +1000
Message-ID: <4211EC43.3030704@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:52621 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261682AbVBOMdf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 07:33:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sakimathew@yahoo.com

SCSI Enclosure Services (SES) permit "the management and
sense the state of power supplies, cooling devices, displays,
indicators, individual drives, and other non-SCSI elements
installed in an enclosure". The scsi_ses adapter driver
simulates a SES device. The default action is to appear as a
disk (actually an 8 MB ramdisk) with associated Enclosure
Services. This is similar to a fibre channel disk with a
SCA-2 connector which includes an Enclosure Services
Interface (ESI). Alternatively the scsi_ses driver can
simulate a simple SES device.

This SES simulator is closely related to the scsi_debug
driver. Unlike scsi_debug which can simulate many disks
(or other scsi device types), scsi_ses simulates a
single disk with an attached SES device. Alternatively it
can simulate a freestanding SES device when the "ses_only=1"
parameter is given.

Further information, usage examples and patches against
lk 2.6.11-rc4 can be found at
http://sg.torque.net/sg/scsi_ses.html

RFC: Does this driver warrant inclusion in the lk 2.6 series?


The current scsi_ses patches do not take into account Mike
Christie's "scsi bus for virtual drivers" changes. These
can be easily applied and will bring the same advantages
as they do to the existing scsi_debug and iSCSI drivers.


Doug Gilbert + Zacharia Mathew
