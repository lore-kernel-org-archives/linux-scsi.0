From: Atul Srinivasan <atul@sierra-da.com>
Subject: kernel 2.6.11.2 / megaraid 2.20.4.5 and /proc question
Date: Fri, 11 Mar 2005 16:32:15 -0800
Message-ID: <4232388F.7070505@sierra-da.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from [209.10.211.37] ([209.10.211.37]:50201 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S261526AbVCLAcQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 19:32:16 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by localhost.localdomain (8.12.8/8.12.8) with ESMTP id j2C0WFup011832
	for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2005 16:32:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I've just build kernel version 2.6.11.2 with the new lsi megaraiddrivers
compiled into the kernel. I think the driver version is 2.20.4.5.

I used to be using a 2.6.7 kernel with an older version of the drivers.
2.00.3.

I'm using a MegaRAID SATA 150-6 card.

With the 2.6.7 kernel there used to be information in /proc/megaraid.
I do not see the same information using the 2.6.11.2 kernel.
Is there anything in /proc using the 2.6.11.2 kernel setup ?
If not there, then anywhere else ?

Also, where might I find information on to forward errors detected bythe
adapter. e.g send mail to an account

Apologies in advance if any of the above questions are not 
appropriatefor this
group, or if they are covered in some doc I have not read.

Thanks,
Atul
