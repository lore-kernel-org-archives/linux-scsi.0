From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: zero block writes
Date: 14 Oct 2003 17:18:46 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066173526.3037.51.camel@patehci2>
References: <1066160907.3501.9.camel@patehci2> <3F8C79F0.6070105@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:42936 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261239AbTJNXS7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2003 19:18:59 -0400
In-Reply-To: <3F8C79F0.6070105@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> Also when I tested this on scsi_debug, it complained
> about getting a NULL data buffer pointer.

CONFIG_SCSI_DEBUG option of .config was new to me, thanks.

> > $ sg_dd of=/dev/sg0 if=/dev/null bs=2k count=1
> > ...
> > usb-storage: Command WRITE_10 (10 bytes)
> ...
> bugs ...

Is this a bug?

Because CONFIG_SCSI_DEBUG complains of NULL pointers?

What patch do you like?  No command at all?  A zeroed command with no
NULL pointers?

I vote for the patch of no command at all because for me sg_dd exists to
let me read and write fragments longer than I can conveniently in the
single cdb of a single SG_IO.  For me sg_dd doesn't exist to pass thru
creative variations of SG_IO.  Ditto for you?

I'm guessing I have a clue what round means near hear because to get
that clue I reinvented the sg_dd wheel myself.  In my pldd I included a
-v option to give me a cdb trace without reconfiguring the kernel to run
slow, so there I noticed this issue more quickly.

> A new beta (1.05) ... tomorrow ...
> one up about 1 hour ago).

Highly responsive, thank you.

I do enjoy perusing the links to the sg home page i.e.
http://www.google.com/search?q=link:www.torque.net/sg/

A google mystery of this moment is why google doesn't yet know that the
page where I discuss my reinvented sg_dd indeed does link to sg utils,

I can prove Google has my page cached.  The search:
http://www.google.com/search?q=LaVarre+pldd
finds:
http://members.aol.com/plscsi/tools/pldd/

Yet seemingly Google hasn't yet parsed all the links from pldd.

Pat LaVarre


