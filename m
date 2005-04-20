From: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Subject: Removing a disk from the qla2xxx driver.
Date: Wed, 20 Apr 2005 10:35:21 +0530
Message-ID: <267988DEACEC5A4D86D5FCD780313FBB0732C84F@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ngate.noida.hcltech.com ([202.54.110.230]:32708 "EHLO
	ngate.noida.hcltech.com") by vger.kernel.org with ESMTP
	id S261407AbVDTFGn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 01:06:43 -0400
Received: from noida.hcltech.com (exch-01.noida.hcltech.com [204.160.254.79] (may be forged))
	by ngate.noida.hcltech.com (8.12.5/8.12.5) with SMTP id j3K56Gpc005878
	for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 10:36:41 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

I do not know whether this is the corect forum to discuss this, but I
recently saw a post related to qla2xxx driver and thought that I may get
some help. I'm using Linux kernel 2.6 and plan to use the qla2xxx driver.

The driver documentstion says it has the "qlascan" command which can help in
adding new disks by the following procedure:

1) First add the Disk to the HBA.
2) # echo "scsi-qlascan" > /proc/scsi/<driver-name>/<adapter-id> (The
qla2xxx driver will rescan)
3) # echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi (The mid-level
will add the device)

However, what I wanted to know was that how can I REMOVE a SCSI device from
the HBA at run time? By logic, I believe that the sequence should be:

1) # echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi (The
mid-level will remove the device)
2) Then remove the Disk from the HBA.
3) # echo "scsi-qlascan" > /proc/scsi/<driver-name>/<adapter-id> (The
qla2xxx driver will rescan, and will remove the disk)

Is the above sequence (for deletion of disk) correct? Can somebody help me
out on this?

I would really appreciate. Any pointers on how to remove a disk at runtime
are welcome.

Thanks & Regards,

Rajat



Disclaimer: 

This message and any attachment(s) contained here are information that is
confidential,proprietary to HCL Technologies and its customers, privileged
or otherwise protected by law.The information is solely intended for the
individual or the entity it is addressed to. If you are not the intended
recipient of this message, you are not authorized to read, forward,
print,retain, copy or disseminate this message or any part of it. If you
have received this e-mail in error, please notify the sender immediately by
return e-mail and delete it from your computer.


