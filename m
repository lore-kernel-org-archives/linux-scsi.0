From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Task Sets in SCSI and Linux
Date: Wed, 08 May 2002 11:34:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205081634.g48GYe304381@localhost.localdomain>
References: <mheinz@infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA05661
	for <linux-scsi@vger.kernel.org>; Wed, 8 May 2002 09:34:45 -0700
In-Reply-To: Message from Michael Heinz <mheinz@infiniconsys.com>
   of "Wed, 08 May 2002 10:54:48 EDT." <8B024BD9-6293-11D6-B607-0003934B22FE@infiniconsys.com>
List-Id: linux-scsi@vger.kernel.org
To: Michael Heinz <mheinz@infiniconsys.com>
Cc: linux-scsi@vger.kernel.org

mheinz@infiniconsys.com said:
>  From perusing the source code it appears to me that the Linux SCSI
> layers do not take advantage of SCSI task sets. Is that correct? 

Could you elaborate on what you mean by "task set"?  SCSI 3 defines a task 
simply as "work to be performed by the logical unit in the form of a command 
or a group of linked commands".  This basically means the I_T_L or I_T_L_Q 
nexus of scsi2, however scsi3 expands this for multi-ported devices.  "task 
set" usually just means the outstanding tasks on a given logical unit, and as 
such it's really a target concept although the initiator must know how to 
track outstanding tasks correctly.

If by "take advantage of SCSI task sets" you mean use tagged tasks to get 
multiple outstanding tasks on a logical unit, the answer is yes but it depends 
on the low level driver implementation.

James Bottomley


