From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 7675] New: LSI Logic Megaraid driver broken
Date: Wed, 13 Dec 2006 11:28:42 -0800
Message-ID: <20061213112842.153647b6.akpm@osdl.org>
References: <200612131531.kBDFVjme006527@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965100AbWLMTtm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Dec 2006 14:49:42 -0500
In-Reply-To: <200612131531.kBDFVjme006527@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bill@crowellsystems.com, Neela.Kolli@engenio.com

On Wed, 13 Dec 2006 07:31:45 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7675
> 
>            Summary: LSI Logic Megaraid driver broken
>     Kernel Version: 2.6.18.2, 2.6.19.1
>             Status: NEW
>           Severity: blocking
>              Owner: io_scsi@kernel-bugs.osdl.org
>          Submitter: bill@crowellsystems.com
> 
> 
> Most recent kernel where this bug did *NOT* occur:2.6.17.4
> Distribution:gentoo
> Hardware Environment:i586
>        Intel 865-based motherboard
>        Intel LSI-based SATA RAID controller
>        P4
> 
> Software Environment:gcc 4.1.1, glibc-2.5
> Problem Description:
> 
> Megaraid driver fails to initialize controller during system boot. Driver is 
> built-in.
> 
> Boot messages show:
> megaraid: 2 outstanding commands. max wait 300 sec
> megaraid mbox: wait for 1 commands to complete:300
> megaraid mbox: reset sequence completed successfully
> megaraid: aborting-7 cmd=12 <c=0 t=1 1=0>
> 
> ***
> Reverting to the legacy Megaraid driver does not allow drives to be opened, so 
> this is not a work-around.
> 
> Steps to reproduce:
> 
> Compile kernel with LSI Megaraid support built-in and try to boot a machine 
> with the driver.
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
