From: Martin Samuelsson <sam@home.se>
Subject: aacraid and S.M.A.R.T
Date: Wed, 30 Jul 2008 23:54:50 +0200
Message-ID: <20080730235450.0fcc21a6.sam@home.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxy2.bredband.net ([195.54.101.72]:64675 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbYG3WPI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 18:15:08 -0400
Received: from ironport.bredband.com (195.54.101.120) by proxy2.bredband.net (7.3.127)
        id 481183330187B1E3 for linux-scsi@vger.kernel.org; Wed, 30 Jul 2008 23:54:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello list,

I have an old Adaptec 2610SA SATA RAID controller with six disks. As I'm a bit curious, I'd like to know, for example, the temperature they report. (afacli can't report those, and I suspect aaccli can't either) It seemed utterly impossible until I saw the expose_physicals module option, but after switching that on, I can at least see traces of the individual disks.

If I understand it correctly, aacraid provides an emulation layer between what I see and the physical disks, passing known commands and responses back and forth. However, S.M.A.R.T commands doesn't seem to be among those known ones, is that correct?

I'm running CentOS 5 with kernel 2.6.18, which is kind of old. Would running a spanking new kernel make me happier and support reading the temperature from the individual disks?

Regards,
/Sam
