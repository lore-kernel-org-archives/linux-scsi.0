From: joystick <joystick@shiftmail.org>
Subject: Write cache and surface error behaviour
Date: Sun, 20 Jul 2014 23:54:26 +0200
Message-ID: <53CC3A92.5000501@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:3227 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750882AbaGTWEg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jul 2014 18:04:36 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by server (Postfix) with ESMTPSA id BF76631313
	for <linux-scsi@vger.kernel.org>; Sun, 20 Jul 2014 17:57:36 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello list,
I don't really understand this disk cache thing.
Suppose a disk with write cache enabled of writeback type: Linux 
receives a write completed notification (a message from the disk) when 
the data has reached the cache of the disk. Correct? At that point it is 
not considered an in-flight I/O anymore. Correct?
So what happens when the disk tries to write it to the platter and 
discovers that there is a media error on that sector? (suppose 
relocation does not happen ; maybe sectors exhausted)
Does Linux receive the write error upon the next flush it issues? So the 
error is related to the flush? And what happens if Linux never issues 
such flush?

Thank you
J.
