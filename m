From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 5910] New: tar to tape-drive kills keyboard,
 makes mouse hang, NMI lock in logfile
Date: Tue, 17 Jan 2006 14:39:59 -0800
Message-ID: <20060117143959.751fc7e0.akpm@osdl.org>
References: <200601172007.k0HK7sSB014313@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:25059 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932201AbWAQWiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 17:38:19 -0500
In-Reply-To: <200601172007.k0HK7sSB014313@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, Andi Kleen <ak@muc.de>

bugme-daemon@bugzilla.kernel.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=5910
> 
>            Summary: tar to tape-drive kills keyboard, makes mouse hang, NMI
>                     lock in logfile

This is a fairly revolting-looking bug.  The keyboard problem could be due
to something else sending keventd into a loop - without keventd services it
seems that USB keyboards won't work, but PS/2 will.

Andi, could you please take a look at the NMI messages here?  Is this a
misinterpreted NMI watchdog message?  I suspect not.

Thanks.
