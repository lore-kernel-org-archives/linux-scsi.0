From: "Lee Xing" <lxing@Crossroads.com>
Subject: Help - can Linux SCSI sub-system add newly-attached devices to /dev on the fly?
Date: Thu, 20 May 2004 11:58:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFFD@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:38580 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S265176AbUETQ6W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 12:58:22 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Does any one know if there is a function low-level driver can invoke to notice
mid-layer the changes on the attached devices?  Suppose we hot plug-in or 
pull-off a disk, can low-level driver send a notice to mid-layer and let it
re-scan the bus and add a new sd/sg to /dev?

I was told we could run "echo scsi add-single-device h c t l > /proc/scsi/scsi" 
(where "h c t l" are host_id, channel_id, target_id and lun_id) from user space 
to add a newly-attached device to mid-layer.  Is it the only way (besides reboot)
to add new devices to mid-layer on the fly?

Mid-layer in lk 2.6 defines two functions, scsi_add_device() and scsi_add_host(),
that can be called by low-level drivers based on the document.  I'm not familiar 
with lk2.6.  Can low-level drivers in lk2.6 call scsi_add_device( ) to add 
newly-attached disks to mid-layer on the fly?  Does lk2.4 provide a similar 
function to scsi_add_device( ) in lk2.6?

Thanks,


Lee

