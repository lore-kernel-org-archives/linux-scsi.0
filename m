From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 7717] New: Tapes unreadable after unload
Date: Wed, 20 Dec 2006 02:50:58 -0800
Message-ID: <20061220025058.70d3d4ea.akpm@osdl.org>
References: <200612201031.kBKAVIJS005240@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54166 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964982AbWLTKv2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Dec 2006 05:51:28 -0500
In-Reply-To: <200612201031.kBKAVIJS005240@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, bgs@bgs.hu


(please respond via emailed reply-to-all)

On Wed, 20 Dec 2006 02:31:18 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7717
> 
>            Summary: Tapes unreadable after unload
>     Kernel Version: tested 2.6.17 through 2.6.29 with various results

I assume that means 2.6.17 and 2.6.19 failed.

>             Status: NEW
>           Severity: blocking
>              Owner: io_scsi@kernel-bugs.osdl.org
>          Submitter: bgs@bgs.hu
> 
> 
> Most recent kernel where this bug did *NOT* occur: 2.6.19

And that means that 2.6.19 did not fail.

Please clarify.

> Distribution: Slackware/Fedora
> Hardware Environment: HP 530, HP Dl380
> Software Environment: tar, mtx
> Problem Description: Doing a tar backup works well. Data is written and is
> readable. Binary restore comparison is ok. After unload/load the tape produces
> Input/output errors. The tape is unreadable with working kernels too. Any
> attempt to restore data from faulty tapes were in vain until now. 
> 
> Steps to reproduce:
> tar cvf /dev/st0 /path/to/something
> mtx -f /dev/sg1 unload
> mtx -f /dev/sg1 load X
> tar tvf /dev/st0
> 
> tar output:
> tar: /dev/st0: Cannot read: Input/output error
> tar: At beginning of tape, quitting now
> tar: Error is not recoverable: exiting now
> 
> All read() attempts fail after 42 bytes. (I can attach those 42 bytes if they
> are of any help).

