From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Fw: [Bugme-new] [Bug 5117] New: Panic when accessing
	scsi-tapedrives with 4G-remap
Date: Sun, 28 Aug 2005 15:20:52 +0200
Message-ID: <1125235253.3219.16.camel@laptopd505.fenrus.org>
References: <20050825172417.217d56af.akpm@osdl.org>
	 <Pine.LNX.4.61.0508261930510.2960@kai.makisara.local>
	 <1125231795l.13191l.4l@serve.riede.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:23452 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750766AbVH1NVF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Aug 2005 09:21:05 -0400
In-Reply-To: <1125231795l.13191l.4l@serve.riede.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>, linux-scsi@vger.kernel.org, JF@vanbaarlen.demon.nl, Andrew Morton <akpm@osdl.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>


> > OK. I booted my test i386 machine with highmem=384m and did some tests. I
> > also added a counter to st.c to count the highmem pages used for zero-copy
> > DMA. I could not get dd to use highmem but with tar that succeeded. No
> > extra messages were found in syslog during these tests.
> > 
> > BUT, at the same time I remembered that the system in the Bugzilla report
> > was Athlon64 running FC3 x86_64. The x86_64 kernel does not have highmem.
> 
> True. I do have a machine running FC4 x86_64, but it doesn't have 4G of  
> memory, so it doesn't do the 4G-remap that the bug report refers to.
> 
> Don't know if there is any way to make it do so (other than buy more memory).


note that some (tyan) amd64 motherboards have a really broken bios wrt
remap, and the only way to get those systems stable is to disable the
memory remap in that bios. If you don't all kinds of funky stuff can and
does happen.


