From: "Lee Xing" <lxing@Crossroads.com>
Subject: Help - interface between Linux SCSI mid-level driver and lower-level driver
Date: Wed, 24 Mar 2004 14:12:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FF7C8@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 65-68-235-6.ded.swbell.net ([65.68.235.6]:7094 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S261179AbUCXUMo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 15:12:44 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm not SCSI driver expert.  Sorry for asking simple questions here.  Your help would be appreciated.

We are working on a new prototype that uses a FC HBA on Linux.  Our FC driver detects the physical FC disks as SCSI devices and reports them to a higher_layer (not Linux SCSI mid-level driver) in Linux kernel.  Now, we need to create another layer that sits in between the existing higher_layer and Linux SCSI mid-level driver, and to register the detected FC/SCSI devices as Linux sd/sg devices.

My question is what are the interface functions in SCSI mid-level driver we can invoke to register the detected FC/SCSI devices as Linux sg/sd devices.  Sample code and documents would be a great help.

Thanks,


L.

