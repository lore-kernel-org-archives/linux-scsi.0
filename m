From: Michael Reed <mdr@sgi.com>
Subject: fibre channel sync cache question
Date: Tue, 25 Jul 2006 17:22:28 -0500
Message-ID: <44C699A4.3030409@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:45236 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932484AbWGYWWd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 18:22:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <James.Smart@Emulex.Com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, Michael Reed <mdr@sgi.com>

Hello All,

Using fibre channel disks, I've noticed that when the system shuts down
that the sd_driver issues a sync cache command to the device.  I've also
noticed that when the lldd is removed via rmmod that this sync cache is
not executed.  I would think that the sync cache would be desirable
under this circumstance.

Was it a conscious decision to not have sync cache executed during
module unload?

Is it desirable?

(There are various reasons why it doesn't work.  The rport port_state
is not ONLINE, the module is being unloaded so that a reference cannot
be acquired, the sdev state is SDEV_CANCEL.  Three strikes and you're
out?)


Mike



