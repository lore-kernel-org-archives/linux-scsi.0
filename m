From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [Bugme-new] [Bug 4268] New: SCSI performance regression in 2.
	6.10
Date: Tue, 1 Mar 2005 08:46:19 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C016EF8A7@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Received: from mail0.lsil.com ([147.145.40.20]:58006 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261947AbVCAPvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 10:51:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, duraid@octopus.com.au

Nope. The last thing I put in was error recovery fix's,
but that should not effect performance.  I'm not sure
whether that when into 2.6.10.  

Do you know if http://linux-scsi.bkbits.net:8080/scsi-rc-fixes-2.6 is down
or moved?
I can't seem to see this website, to see whether there were any patches
applied outside what I have sent.

I will validate performance here.

Eric Moore
LSI Logic

On Tuesday, March 01, 2005 12:12 AM, Andrew Morton wrote:
> 
> 
> 
> Did anything change in the mpt fusion driver?
> 
> I'm seeing the same thing, again with mpt-fusion.  38MB/sec 
> when it should
> be getting >60.
> 
> 
> Begin forwarded message:
> 
> Date: Mon, 28 Feb 2005 22:03:57 -0800
> From: bugme-daemon@osdl.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 4268] New: SCSI performance 
> regression in 2.6.10
> 
> 
> http://bugme.osdl.org/show_bug.cgi?id=4268
> 
>            Summary: SCSI performance regression in 2.6.10
>     Kernel Version: 2.6.10
>             Status: NEW
>           Severity: normal
>              Owner: andmike@us.ibm.com
>          Submitter: duraid@octopus.com.au
> 
> 
> Distribution: Debian 'unstable', pristine 2.6.10 kernel
> Hardware Environment: HP rx2600 (ia64), LSI 53C1030 U320 SCSI 
> host (Fusion MPT)
> Problem Description: There is a quite severe performance 
> regression in 2.6.10
> when using SCSI disk drives. (I've tested against 2.4.20, 
> 2.6.8 and 2.6.9, none
> of which exhibit this problem)
> 
> Steps to reproduce: dd if=/dev/sdXX of=/dev/null bs=1048576 
> count=10000
> (streaming read the first 10GB of scsi disk XX)
> 
> In 2.6.10, with a Fujitsu 10Krpm SCSI disk I get 34MB/sec, 
> with a Maxtor 15Krpm
> SCSI disk I get 37MB/sec. CPU usage of 'dd' is ~2% and 
> %system time is about the
> same.
> 
> Using 2.6.9 (or earlier), I get 63MB/sec for the 10K disk and 
> 95MB/sec for the
> 15K disk. CPU usage goes up in proportion. (OK, fair enough.)
> 
> This is a real performance issue (shows up everywhere, not 
> just in 'dd'), and
> affects both reads and writes. Does anyone know what's going on here?
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
