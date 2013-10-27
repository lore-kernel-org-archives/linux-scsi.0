From: joystick <joystick@shiftmail.org>
Subject: Question on TCQ/NCQ and write cache
Date: Sun, 27 Oct 2013 02:33:10 +0200
Message-ID: <526C5F46.2080100@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:1941 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753344Ab3J0Amw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Oct 2013 20:42:52 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by server (Postfix) with ESMTPSA id DFB1831353
	for <linux-scsi@vger.kernel.org>; Sat, 26 Oct 2013 20:36:18 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello list,
did I understand correctly that the writes are acknowledged by the 
HDDs/SSDs when the data is on the write cache, and not on the platters, 
and this is independent from the current setting of NCQ (enabled / 
disabled)?
So the NCQ being enabled only allows to save the latency of the trip of 
the write commands on the wire up to the DRAM cache on the HDD plus the 
reception of an ack in the opposite direction (analogous to one round 
trip ping time in networking), by issuing multiple of them before 
receiving the first ack (analogous to the window of TCP)?
So NCQ has nothing to do on write performance of the disk per-se?

I'm asking because browsing around I found this:
http://en.wikipedia.org/wiki/Native_Command_Queuing
see the image 
http://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/NCQ.svg/300px-NCQ.svg.png

This apparently tells that the write order is strictly sequential in 
non-NCQ mode while it can be nonsequential with NCQ, but I'm starting to 
think this is wrong otherwise what would be the role of the drive's 
write cache?

(I am restricting the question to writes only for now)

Thank you
J.
