From: "Nagpure, Dinesh" <Dinesh.Nagpure@stratus.com>
Subject: RE: One question about SCSI device hotplug
Date: Tue, 1 Mar 2005 10:20:04 -0500
Message-ID: <CAC3BCBB443DEC439198F230B4BCC7E9092C45D5@exna6-ftsaa.mis.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Received: from mailhub2.stratus.com ([134.111.1.16]:45448 "EHLO
	mailhub2.stratus.com") by vger.kernel.org with ESMTP
	id S261937AbVCAPVX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 10:21:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Zhao, Forrest'" <forrest.zhao@intel.com>, linux-scsi@vger.kernel.org
Cc: "Caushik, Ramesh" <ramesh.caushik@intel.com>

If you are trying to automate the process then taking a look at SCSI RAS
tools at http://scsirastools.sourceforge.net might help. I am not sure how
much are these tools in use around (any comments?). Alternatively If you are
running on a disk hot-swap capable system the enclosure service processor
might provide you information on SCSI topology change.

-dinesh
 

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Zhao, Forrest
Sent: Tuesday, March 01, 2005 4:07 AM
To: linux-scsi@vger.kernel.org
Cc: Caushik, Ramesh
Subject: One question about SCSI device hotplug


Hi, list

If I surprisingly hot-remove a SCSI disk from HBA manually 
without executing "echo "scsi remove-single-device
 <h> <b> <t <l>" > /proc/scsi/scsi", can the "hotplug"
event be notified to SCSI mid-layer or user space?

I briefly browse some code of LLDD, it seems that LLDD never
report "hotplug" event to upper-level layer. Am I right?


Thanks,
Forrest
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
