From: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Subject: When & how is the SCSI strategy routine called?
Date: Tue, 22 Mar 2005 22:35:58 +0530
Message-ID: <267988DEACEC5A4D86D5FCD780313FBB05FA9B2E@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kernel-newbies@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Hi list,

Tracing the kernel 2.6.8 code I found that scsi_mod maintains separate
request queues for each SCSI device. It uses the block layer queuing
facility to do this. What I could not find out was that once a request is
queued into a queue (for a particular device), WHEN and HOW is the strategy
routine "scsi_request_fn()" called ?

All I could find on the net was that "The kernel calls the strategy routine
when ever it believes that it is appropriate to invoke it."

Please help ... Any pointers will be highly appreciated.

TIA,

Rajat


Disclaimer: 

This message and any attachment(s) contained here are information that is
confidential,proprietary to HCL Technologies and its customers, privileged
or otherwise protected by law.The information is solely intended for the
individual or the entity it is addressed to. If you are not the intended
recipient of this message, you are not authorized to read, forward,
print,retain, copy or disseminate this message or any part of it. If you
have received this e-mail in error, please notify the sender immediately by
return e-mail and delete it from your computer.
