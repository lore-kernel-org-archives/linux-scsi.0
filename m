From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 7951] New: ESP DMA error
Date: Tue, 6 Feb 2007 13:29:17 -0800
Message-ID: <20070206132917.ccd7348b.akpm@linux-foundation.org>
References: <200702061754.l16HsxR6031831@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <200702061754.l16HsxR6031831@fire-2.osdl.org>
Sender: sparclinux-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, mt1@systella.fr, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 6 Feb 2007 09:54:59 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7951
> 
>            Summary: ESP DMA error
>     Kernel Version: 2.6.20
>             Status: NEW
>           Severity: normal
>              Owner: io_scsi@kernel-bugs.osdl.org
>          Submitter: mt1@systella.fr
> 
> 
> Most recent kernel where this bug did *NOT* occur: 2.6.19.1
> Distribution: debian testing
> Hardware Environment: SparcSTATION 20 smp
> Software Environment:
> Problem Description: ESP driver returns some DMA errors and hard drives are
> disconected.
> 
> Steps to reproduce: build a 2.6.20 kernel with ESP driver and do for example an
> apt-get dist-upgrade to obtain a heavy traffic on internal SCSI bus.
> 

Apparently a recent regression.
