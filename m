From: devnetfs <devnetfs@yahoo.com>
Subject: fast detection of  loss of FC connectivity?
Date: Thu, 3 Apr 2003 09:15:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030403171558.37579.qmail@web20414.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web20402.mail.yahoo.com ([66.163.169.90]:12043 "HELO
	web20414.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261386AbTDCREb
	(for <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2003 12:04:31 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

In a SAN setup is it possible to quickly detect that a FC cable
has been plugged out of the card? Presently the way I do is send
a SCSI-2 TUR cmd to the device (periodically) and check if the 
device is reachable.

When the cable is pulled out, TUR fails indicating some problem. But
TUR command takes a LONG time to complete before returning an error.
This time is more than 8-10secs :( Thats too slow. 

I noticed that as soon as I pull the cable I get a LOOP DOWN message
on the console (its a qlogic card, qla2x00 driver). Is there a 
generic flag in the scsi-midlayer (part of Scsi_Host) that would
let me know that has happend -- hence quickly determine loss of
connectivity. 

I looked at the qlogic source and they have a loop_state field in 
scsi_qla_host, but then thats specific to a particular card.

Is there a generic way to QUICKLY detect such loss of connectivity,
in a FC setup?

Any ideas/suggestions are welcome :)

Thanks
A.


