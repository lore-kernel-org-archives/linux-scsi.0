From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Mon, 23 Nov 2009 22:12:09 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0911232208570.18907@kai.makisara.local>
References: <bug-14563-11613@http.bugzilla.kernel.org/> <200911231210.nANCA60H019503@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:35183 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbZKWUM3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2009 15:12:29 -0500
In-Reply-To: <200911231210.nANCA60H019503@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Mon, 23 Nov 2009, bugzilla-daemon@bugzilla.kernel.org wrote:

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
> 
Are you sure that you have used the patched st? The log does not show the 
the debugging output from Fujita's patch. It also shows the problem 
occurring before the patch:

st0: Block size: 524288, buffer size: 516096 (0 blocks).

Kai

