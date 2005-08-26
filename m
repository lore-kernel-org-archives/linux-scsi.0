From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Fw: [Bugme-new] [Bug 5117] New: Panic when accessing scsi-tapedrives
 with 4G-remap
Date: Fri, 26 Aug 2005 19:38:08 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0508261930510.2960@kai.makisara.local>
References: <20050825172417.217d56af.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:28061 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S965099AbVHZQd1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 12:33:27 -0400
In-Reply-To: <20050825172417.217d56af.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: osst@riede.org, JF@vanbaarlen.demon.nl, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>

On Thu, 25 Aug 2005, Andrew Morton wrote:

> 
> 
> Begin forwarded message:
> 
> Date: Tue, 23 Aug 2005 12:53:38 -0700
> From: bugme-daemon@kernel-bugs.osdl.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 5117] New: Panic when accessing scsi-tapedrives with 4G-remap
> 
> 
>  http://bugzilla.kernel.org/show_bug.cgi?id=5117
> 
>             Summary: Panic when accessing scsi-tapedrives with 4G-remap
>      Kernel Version: 2.6.12.5
> 
> 
> Could this purely be a highmem problem?   Is the zero-copy DMA feature of
> st.c known to work OK with x86 highmem?

It is _not_ known _not_ to work ;-) I.e., I have received neither any 
success nor any failure reports. I have not tested it because I don't have 
any machine with enough memory (and I have not hacked a kernel to use 
highmem with 512 MB of memory). I hope someone seeing this thread and 
using highmem with tape can comment on this subject.

-- 
Kai
