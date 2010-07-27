From: Mike Christie <michaelc@cs.wisc.edu>
Subject: dev_loss_tmo behavior question
Date: Tue, 27 Jul 2010 16:11:48 -0500
Message-ID: <4C4F4B94.1070009@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39662 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab0G0VIO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 17:08:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>, brking@linux.vnet.ibm.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.>

Hi FC driver developers,

I am trying to figure out what is the correct behavior when setting 
dev_loss_tmo.

With lpfc, qla2xx, and ibmfc if I set dev_loss_tmo using 
/sys/class/fc_remote_port/rport-xx/dev_loss_tmo, and then we add devices 
the slave_configure functions for these drivers reset the dev_loss_tmo 
to a driver value.

The addition of devs could be from something like a user rescan, or from 
a scan started by a remote port addition.

With fcoe, fnic, mptfc, bfa and zfcp the dev_loss_tmo value set from 
sysfs will not be reset by a driver value on rescans.

Which drivers should be changed?
