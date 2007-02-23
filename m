From: pcaldes <pcaldes@attglobal.net>
Subject: aacraid not detecting drives if compiled into kernel
Date: Thu, 22 Feb 2007 19:35:15 -0600
Message-ID: <45DE44D3.3080800@attglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc15.comcast.net ([63.240.77.85]:62941 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbXBWBn0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Feb 2007 20:43:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm using the Redhat kernel-2.4.21-47.EL on an IBM x3550 server which 
has a IBM ServeRAID 8k-l controller.
I recompiled kernel to include the aacraid driver in the kernel (not as 
a module) for use with a bootcd.
CONFIG_SCSI=y
CONFIG_BLK_DEV_SD=y
CONFIG_SCSI_AACRAID=y

When the kernel loads, the aacraid driver initializes but it does not 
find the drive.
If I force the SCSI subsystem to rescan the host adapters, the aacraid 
driver finds the drive.
    # echo "scsi scan-new-devices" > /dev/scsi/scsi

However, if I compile the aacraid driver as a module, when I do a 
'modprobe aacraid' the driver loads and finds the drive.

Any ideas on what is wrong and how to get around this?
I really need to have the aacraid driver compiled into the kernel for 
various reasons to avoid using an initrd.

