From: Anil kumar <anils_r@yahoo.com>
Subject: scsi_cmnd data_buffer checksum
Date: Wed, 8 Sep 2010 20:36:32 -0700 (PDT)
Message-ID: <35352.83946.qm@web32402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


I am writing a checksum calculation of scsi_cmnd data buffer in the driver. 

I calculate the checksum of the scsi_cmd data buffer(request_buffer) in driver queuecommand.

Now when the command is completed from the hardware and before driver sends it back to mid-layer, I calculate the checksum again of the same scsi_cmd data_buffer again.

Sometimes the checksums don't match. I mean somehow looks like OS changed the scsi_cmd data_buffer(request_buffer) in the meantime when driver is working on the command.
I print the address of the scsi_cmd data_buffer (virtual address) and its same and the contents of the buffer is also same during both the calculations.
 
Can this happen?



      
