From: Mario Giammarco <mgiammarco-ml@4warding.com>
Subject: LSI Logic 40919o fibre channel: scsi works ip not
Date: Thu, 15 Feb 2007 23:06:25 +0100
Message-ID: <200702152306.25374.mgiammarco-ml@4warding.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp01.kpnqwest.it ([212.97.32.22]:3992 "EHLO
	smtp01.kpnqwest.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161565AbXBOWeL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2007 17:34:11 -0500
Received: from [10.0.0.17] (89-186-69-2.dcpool.ip.kpnqwest.it [89.186.69.2])
	by smtp01.kpnqwest.it (Postfix) with ESMTP id 3D06231B60
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2007 23:06:29 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have two lsi logic 40919o 2gbit connected to a 2gbit switch.

They see hard disks but when I try to use them as ip card I obtain a partial 
failure: packets sometimes arrives sometimes no and on dmesg I see:

mptlan: ioc0/fc0: WARNING - IOC out of buckets! (priv->buckets_out =
126)
mptlan Mismatch between driver's buckets_out count and fw's
BucketsRemaining count has crossed the threshold, issuing a LanReset
to clear the fw's hashtable. You may want to check your
/var/log/messages for "CRC error" event notifications.
mptlan: ioc0/fc0: WARNING - IOC out of buckets! (priv->buckets_out =
125)
mptlan Mismatch between driver's buckets_out count and fw's
BucketsRemaining count has crossed the threshold, issuing a LanReset
to clear the fw's hashtable. You may want to check your
/var/log/messages for "CRC error" event notifications.
mptlan: ioc0/fc0: IOC says 1 buckets left. (priv->buckets_out = 126)
mptlan Mismatch between driver's buckets_out count and fw's
BucketsRemaining count has crossed the threshold, issuing a LanReset
to clear the fw's hashtable. You may want to check your
/var/log/messages for "CRC error" event notifications.
mptlan: ioc0/fc0: WARNING - IOC out of buckets! (priv->buckets_out =
126)


Boards are upgraded to latest bios I have tried several kernels.

Please tell me if you need other details.

Thanks in advance for any help.
