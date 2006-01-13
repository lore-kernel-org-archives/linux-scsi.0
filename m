From: Srdjan Todorovic <todorovic.s@googlemail.com>
Subject: Re: [Bug] crash with kernel >= 2.6.14 with k3b and scsi driver
Date: Fri, 13 Jan 2006 23:29:58 +0000 (GMT)
Message-ID: <Pine.LNX.4.62.0601132326170.5687@tigerclaw.lan>
References: <Pine.LNX.4.62.0601131215550.5667@tigerclaw.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uproxy.gmail.com ([66.249.92.195]:45025 "EHLO uproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1423098AbWAMXYo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 18:24:44 -0500
Received: by uproxy.gmail.com with SMTP id s2so82606uge
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 15:24:42 -0800 (PST)
In-Reply-To: <Pine.LNX.4.62.0601131215550.5667@tigerclaw.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, 13 Jan 2006, Srdjan Todorovic wrote:
> I get a kernel crash with kernels >= 2.6.14 on my system when I load
> k3b application. The crash only happens if the SCSI driver is loaded.
[snip]
> I will be trying out 2.6.15-git* today.

The bug report is at http://bugzilla.kernel.org/show_bug.cgi?id=5776
I've also attached to the report the dmesg output.

Thanks
 - Srdjan Todorovic
