From: Greg Stitt <gstitt@gmail.com>
Subject: old and new megaraid drivers for linux
Date: Thu, 16 Dec 2004 21:59:03 -0500
Message-ID: <f8d4a352041216185958bf6190@mail.gmail.com>
Reply-To: Greg Stitt <gstitt@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.193]:48011 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262727AbULQC7E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2004 21:59:04 -0500
Received: by wproxy.gmail.com with SMTP id 36so12807wra
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2004 18:59:03 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I currently have a system with both a PERC2/SC, and a recently added
MegaRAID SATA 150-6.

The PERC2/SC ran fine with the 'old style' megaraid driver (2.00.3). 
However, the SATA card has issues with this driver, as I can't even
format the drives without problems.   Under Windows 2003, both cards
operate fine, so I don't believe this is a hardware issue.

I tried the new megaraid driver (2.20.4.0), but it doesn't recognize
the PERC at all.  Not sure how stable it is with the SATA though, as
the PERC contains all the OS. :-)

This was tried using the 2.6.9 linux kernel.

I've seen mention of this issue before on this list, but has anything
been done since then to resolve this?

Thanks
Greg Stitt
