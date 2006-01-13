From: Srdjan Todorovic <todorovic.s@googlemail.com>
Subject: [Bug] crash with kernel >= 2.6.14 with k3b and scsi driver
Date: Fri, 13 Jan 2006 12:27:01 +0000 (GMT)
Message-ID: <Pine.LNX.4.62.0601131215550.5667@tigerclaw.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.205]:45286 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1422638AbWAMMVy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 07:21:54 -0500
Received: by zproxy.gmail.com with SMTP id 13so599165nzn
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 04:21:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

I get a kernel crash with kernels >= 2.6.14 on my system when I load
k3b application. The crash only happens if the SCSI driver is loaded.

I created a bug report with more information, but I think I messed
up the bug report procedure (it's my first time, sorry) as linux-scsi
list is not in the CC. This can probably be corrected very easily but
I wasn't sure it was going to spam you all.

Bugzilla bug ID: 5776

I've tested 11 kernels so far; the last one tested, 2.6.15 crashed.
I will be trying out 2.6.15-git* today.

Let me know what other debug info would be useful, or anything else
I could try out.

Thank you for your time.

 - Srdjan Todorovic
