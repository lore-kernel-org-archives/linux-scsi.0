From: Mark Lobo <ntdeveloper2002@yahoo.com>
Subject: kernel addresses
Date: Mon, 28 Oct 2002 13:22:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021028212220.80695.qmail@web80312.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello!
I am an NT guy just getting into Linux stuff. Im going
to be writing a SCSI initiator driver for an FC HBA. 

Had a couple of simple questions.
1) What exactly is the difference between Kernel
logical and kernel virtual addresses? is the kernel
logical address the address space of the kernel? 
Seems like kernel logical address have a constant
offset from the physical address, and kernel virtual
addresses dont. Its slightly confusing on why have
these two separate terms at all? a kmalloced buffer
gives a logical address, but a vmalloced gives a
kernel virtual address. This kind of terminology
confused me!

2) If a SCSI command is passed by a user level app, is
there a buffer copy involved before it gets to the
scsi initiator? I saw something about bounce buffers,
but wasnt quite sure what it meant. So what are bounce
buffers used for? 
Does the original buffer allocated by the user get
mapped into a kernel virtual ( or logical???) address,
locked down and passed down the stack? 

Any help is greatly appreciated.

Thanks,
Mark



__________________________________________________
Do you Yahoo!?
New DSL Internet Access from SBC & Yahoo!
http://sbc.yahoo.com
