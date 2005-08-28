From: Willem Riede <osst@riede.org>
Subject: Re: Fw: [Bugme-new] [Bug 5117] New: Panic when accessing
 scsi-tapedrives with 4G-remap
Date: Sun, 28 Aug 2005 12:23:15 +0000
Message-ID: <1125231795l.13191l.4l@serve.riede.org>
References: <20050825172417.217d56af.akpm@osdl.org>
	<Pine.LNX.4.61.0508261930510.2960@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:9096 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S1751143AbVH1MXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2005 08:23:23 -0400
In-Reply-To: <Pine.LNX.4.61.0508281333280.13411@kai.makisara.local> (from
	Kai.Makisara@kolumbus.fi on Sun Aug 28 06:40:04 2005)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Andrew Morton <akpm@osdl.org>, JF@vanbaarlen.demon.nl, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>

On 08/28/2005 06:40:04 AM, Kai Makisara wrote:
> On Fri, 26 Aug 2005, Kai Makisara wrote:
> 
> > On Thu, 25 Aug 2005, Andrew Morton wrote:
> >
> > > Could this purely be a highmem problem? Is the zero-copy DMA feature of
> > > st.c known to work OK with x86 highmem?
> >
> > It is _not_ known _not_ to work ;-) I.e., I have received neither any
> > success nor any failure reports. I have not tested it because I don't have
> 
> > any machine with enough memory (and I have not hacked a kernel to use
> > highmem with 512 MB of memory). I hope someone seeing this thread and
> > using highmem with tape can comment on this subject.
> >
> OK. I booted my test i386 machine with highmem=384m and did some tests. I
> also added a counter to st.c to count the highmem pages used for zero-copy
> DMA. I could not get dd to use highmem but with tar that succeeded. No
> extra messages were found in syslog during these tests.
> 
> BUT, at the same time I remembered that the system in the Bugzilla report
> was Athlon64 running FC3 x86_64. The x86_64 kernel does not have highmem.

True. I do have a machine running FC4 x86_64, but it doesn't have 4G of  
memory, so it doesn't do the 4G-remap that the bug report refers to.

Don't know if there is any way to make it do so (other than buy more memory).

Regards, Willem Riede.

