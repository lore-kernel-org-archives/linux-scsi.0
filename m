From: Douglas Gilbert <dougg@torque.net>
Subject: scsi_device::single_lun name change
Date: Wed, 16 Feb 2005 10:57:39 +1000
Message-ID: <42129A83.7010207@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:8405 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261623AbVBPA5D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 19:57:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

While looking at struct scsi_target in a recent lk 2.6
kernel I was confused by this sentence:

"scsi_target: representation of a scsi target, for now,
  this is only used for single_lun devices." This is just above
the definition of the scsi_target structure in scsi_device.h

Elsewhere in that file scsi_device::single_lun is defined
with this comment:
"Indicates we should only allow I/O to one of the luns for
  the device at a time."
That implies that the target must have multiple lus when
single_lun is set :-)

Is it too late to rename that field to something like:
    serialize_lu_io  or single_lu_io ?

Doug Gilbert
