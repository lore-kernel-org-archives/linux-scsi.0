From: Borislav Petkov <bp@amd64.org>
Subject: Re: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Mon, 18 Jun 2012 16:29:00 +0200
Message-ID: <20120618142900.GA9710@aftab.osrc.amd.com>
References: <87obojef7t.fsf@schwinge.name>
 <20120616181008.GB20623@liondog.tnic>
 <87ehpddw9k.fsf@schwinge.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:37787 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2FROiX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2012 10:38:23 -0400
Content-Disposition: inline
In-Reply-To: <87ehpddw9k.fsf@schwinge.name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Schwinge <thomas@codesourcery.com>
Cc: Borislav Petkov <bp@alien8.de>, debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jun 18, 2012 at 07:28:07AM +0200, Thomas Schwinge wrote:
> > Let me guess: AMD K8?
> 
> Correct.
> 
> > Also, can I get /proc/cpuinfo please?
> 
>     $ cat < /proc/cpuinfo
>     processor       : 0

Ok, a single core.

>     vendor_id       : AuthenticAMD
>     cpu family      : 15
>     model           : 47
>     model name      : AMD Sempron(tm) Processor 3000+
>     stepping        : 2
>     cpu MHz         : 1000.000
>     cache size      : 128 KB
>     fpu             : yes
>     fpu_exception   : yes
>     cpuid level     : 1
>     wp              : yes
>     flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext 3dnow up rep_good nopl pni lahf_lm
>     bogomips        : 2000.16
>     TLB size        : 1024 4K pages
>     clflush size    : 64
>     cache_alignment : 64
>     address sizes   : 40 bits physical, 48 bits virtual
>     power management: ts fid vid ttp tm stc

Ok, can you do the following:

$ setpci -s 18.0 0x68.l

and

$ rdmsr 0xc001001f

and send me the output of both commands. Btw, rdmsr should be in a
package called msr-tools, at least on Debian.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
