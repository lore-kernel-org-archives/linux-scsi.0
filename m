From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Wed, 25 Nov 2009 09:21:42 +0900
Message-ID: <20091125092126S.fujita.tomonori@lab.ntt.co.jp>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
	<200911231210.nANCA60H019503@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:54029 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933257AbZKYAVw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2009 19:21:52 -0500
In-Reply-To: <200911231210.nANCA60H019503@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, linux-kernel@jmbreuer.net
Cc: linux-scsi@vger.kernel.org

On Mon, 23 Nov 2009 12:10:06 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14563
> 
> 
> 
> 
> 
> --- Comment #18 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-23 12:10:04 ---
> Created an attachment (id=23877)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=23877)
> Console output, 2.6.30.3, fixed tape block size 512k, patch by FUJITA Tomonori
> 2009-11-19
> 
> The patch you sent changes the behavior: I still get the EIO after (in this
> case) 239 I/O requests while writing to the tape; but the machine no longer
> hard-crashes with a BUG.
> 
> [I've removed the try_rdio=0/try_wdio=0 module parameters for this test.]
> 
> Attached is the console log as usual with my comments interspersed; if I read
> this correctly "st0: Number of r/w requests 239, dio used in 1, pages 128."
> direct I/O is used at least once before the problem occurs.

As Kai said, it doesn't look like a kernel log with the patch
applied. With the patch, the kernel becomes more verbose.

Can you check again?

Thanks,
