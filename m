From: LinuxSysPro <linuxsyspro@gmail.com>
Subject: SCSI Reservation Conflicts errors.
Date: Wed, 15 Apr 2009 21:38:30 -0700 (PDT)
Message-ID: <23071311.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:47679 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZDPEib (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 00:38:31 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1LuJMs-0003PR-6A
	for linux-scsi@vger.kernel.org; Wed, 15 Apr 2009 21:38:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi All,

I'm getting many reservation conflicts error messages on initiator
size when logged-in to the iSCSI target device. Please help me in
resolving this problem.

In the target size we have Persistent Reservation implemented and I am
adding Mode Pages support in the target side. So is it due to the this
persistent reservation? Or what is the reason of getting those
conflicts? Correct me if I am wrong.

I read the SPC-3 & SBC, but I am not cleared(understood) regarding
this Reservation Conflicts.

Please help me.

Thanks in advance. 
-- 
View this message in context: http://www.nabble.com/SCSI-Reservation-Conflicts-errors.-tp23071311p23071311.html
Sent from the linux-scsi mailing list archive at Nabble.com.

