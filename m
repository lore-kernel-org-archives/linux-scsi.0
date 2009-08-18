From: "Auld, Brian (LeftHand Networks)" <brian.auld@hp.com>
Subject: device/volume info on transport removal
Date: Tue, 18 Aug 2009 18:47:50 +0000
Message-ID: <06C3D92ADC647D45918996C82BFB6B996C6325B79C@GVW0433EXB.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:37780 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZHRSsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 14:48:22 -0400
Received: from G6W0641.americas.hpqcorp.net (g6w0641.atlanta.hp.com [16.230.34.77])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by g1t0029.austin.hp.com (Postfix) with ESMTPS id 55F4A38441
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2009 18:48:24 +0000 (UTC)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I have a question about the lifetime of volume/disk info for SAN disks.
 
Say my server has discovered a disk/volume on a SAN (iscsi or fc).  A connection is established at the transport layer.  Presumably disk information (eg. vpd inquiry data and the like) is saved in a layer (SBC disk layer?) above the transport.
 
What happens if the server explicitly logs out of the session for the above disk/volume using whatever initiator tools are available to them?  Does the disk/volume info remain for some time in the higher layer(s) or do all the data structures related to that disk/volume get unplugged/removed when the transport connection is taken away?  Of course, it goes without saying that no other objects in the OS (files, devices, mountpoints) are using the disk when the logout occurs.
Thanks,
Brian
 
p.s. please include my email in the reply to or cc.


