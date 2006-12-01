From: "Ariel Burbaickij" <ariel.burbaickij@gmail.com>
Subject: ABORT operation started/completed and how I can help you to help me
Date: Fri, 1 Dec 2006 19:31:17 +0100
Message-ID: <3058f9b40612011031g97bc109s4ef59193055ea5ed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:47195 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S1031702AbWLASbT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Dec 2006 13:31:19 -0500
Received: by ug-out-1314.google.com with SMTP id 44so2500104uga
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2006 10:31:17 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello dear mailing list participants,
on one of my machines which uses
sym53c8xx_2 driver and sym53c860
chip I get A LOT of messages on the console
announcing that ABORT operation has started
completed and control msgout with some
increasing value. The disc itself works in
the sense that filesystem are fine, files
can be created read from and written to.
Now, these strings cannotbe found directly in the
source of the driver at least not during cursory examination.
I assume that there is nothing good in these
messages and even more so if I mention
that the driver hang for some 10-15 minutes
during the bootup of the system. Now, I would
like to understand what is going on, so several
questions:
1) What do these ABORT operation ... messages mean?
2) What is the meaning of the values after msgout?
3) Under what circumstances are they  normally generated?

If you need some more help from me in order to help you
to answer these questions, certainly feel free to request
some addtional information that might be needed.

/wbr
Ariel Burbaickij
