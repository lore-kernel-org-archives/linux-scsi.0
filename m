From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 6080] New: New Megaraid Module Problem
Date: Wed, 15 Feb 2006 14:32:34 -0800
Message-ID: <20060215143234.1601fb65.akpm@osdl.org>
References: <200602152214.k1FMEuhK012133@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:56238 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751010AbWBOWds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Feb 2006 17:33:48 -0500
In-Reply-To: <200602152214.k1FMEuhK012133@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela Syam Kolli <Neela.Kolli@engenio.com>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, Ju Seokmann <Seokmann.Ju@engenio.com>

bugme-daemon@bugzilla.kernel.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=6080
> 
>            Summary: New Megaraid Module Problem
>     Kernel Version: 2.6.*
>             Status: NEW
>           Severity: blocking
>              Owner: andmike@us.ibm.com
>          Submitter: fturkmen@gmail.com
> 
> 
> Most recent kernel where this bug did not occur: 2.4.18
> Distribution: SUSE 9.2, 10, Mandriva 2006, Fedora 2.0
> 
> Hardware Environment: HP LH 6000, LSILogic controllers 
> 
> Software Environment: Megaraid modules
> 
> Problem Description:
> I have 3 HP LH 6000 machines and wanted to install Linux on them.
> Everytime the install
> hangs on "searching for info file" phase.
> 
> The following messages are given:
>  megaraid: ABORTING-1 cmd=12 <c=0 t=0 l=0>
>  megaraid: ABORTING-1[7d], fw owner.
> 
> when installing megaraid modules ("insmod /modules/megaraid.ko").
> 
> 
> As I searched through the Internet, the old megaraid modules (in kernel
> 2.4) work fine with these devices. I could successfully install SUSE 8.0.
> But I tried SUSE 10, Mandriva 2006, Fedora 2.0  (kernel 2.6.*) and the
> installation hanged on at exactly the same phase.
> 
> 
> 
> Ps: Reported to the maintainer (Ju, Seokmann)
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
