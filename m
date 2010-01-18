From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 15007] SCSI host adapter's scatter-gather list size Issue
Date: Mon, 18 Jan 2010 13:18:04 +0900
Message-ID: <20100118130236M.fujita.tomonori@lab.ntt.co.jp>
References: <bug-15007-11613@http.bugzilla.kernel.org/>
	<201001150249.o0F2nrcc021199@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:51543 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab0ARESK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jan 2010 23:18:10 -0500
In-Reply-To: <201001150249.o0F2nrcc021199@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Fri, 15 Jan 2010 02:49:53 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=15007
> 
> 
> 
> 
> 
> --- Comment #6 from nick cheng <nick.cheng@areca.com.tw>  2010-01-15 02:49:48 ---
> OK. I got it.
> But based on 128 sg entries issue on my original driver I found it bugs every
> time while doing mkfs.ext3 on a default NTFS filesystem, but if I do it on a
> ext3 filesystem, it works smoothly.

Do you mean that 128 sg entries don't cause any problems during
performing mkfs on ext3? If so, I have no idea.


> Besides, it bugs on SMP platforms always but doesn't on non-SMP plaform.
> Can your inference explain it?

Do you mean that 128 sg entries don't cause any problems on non SMP
boxes? If so, I have no idea. Your driver should hit this bug with any
boxes.
