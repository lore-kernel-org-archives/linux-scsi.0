From: "Ju, Seokmann" <sju@lsil.com>
Subject: RE: [Bugme-new] [Bug 4201] New: megaraid crashes at random with C
	ERC ATA100/4ch (DELL Controller) on PowerEdge 600SC
Date: Mon, 14 Feb 2005 08:29:41 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57036626A7@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:6385 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261431AbVBNN37 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 08:29:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Morton' <akpm@osdl.org>, linux-scsi@vger.kernel.org
Cc: Steven_Nash@compuserve.com, "Ju, Seokmann" <sju@lsil.com>

On Friday, February 11, 2005 7:29 PM, Andrew wrote:
> megaraid driver crashing.  I have tried forcing the old megaraid driver in
> the
> kernel config and rebuilding but this has no effect.

Can you provide details on following,please?
- The megaraid driver version?
- Device configuration information on the CERC ATA100/4ch with options
(cached, WT/WB, or read-ahead?)
- Size of main memory on PowerEdge 600SC?
- What are the typical I/O loads has been applied to reach crash?

Thanks,

Seokmann
LSI Logic Corporation.

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@osdl.org]
> Sent: Friday, February 11, 2005 7:29 PM
> To: linux-scsi@vger.kernel.org
> Cc: Steven_Nash@compuserve.com
> Subject: Fw: [Bugme-new] [Bug 4201] New: megaraid crashes at random with
> CERC ATA100/4ch (DELL Controller) on PowerEdge 600SC
> 
> 
> 
> Begin forwarded message:
> 
> Date: Fri, 11 Feb 2005 16:08:26 -0800
> From: bugme-daemon@osdl.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 4201] New: megaraid crashes at random with CERC
> ATA100/4ch (DELL Controller) on PowerEdge 600SC
> 
> 
> http://bugme.osdl.org/show_bug.cgi?id=4201
> 
>            Summary: megaraid crashes at random with CERC  ATA100/4ch (DELL
>                     Controller) on PowerEdge 600SC
>     Kernel Version: 2.6.10
>             Status: NEW
>           Severity: high
>              Owner: andmike@us.ibm.com
>          Submitter: Steven_Nash@compuserve.com
> 
> 
> Distribution: Fedora Core 3
> Hardware Environment: x86 (32 bit)
> Software Environment: Vanilla Kernel & Fedora Build Kernel
> Problem Description: After a day or two (varies) the system hangs and the
> only
> option is to hit the reset button.  Sometimes sda errors appear on the
> current
> active VT but nothing appears in the logs after reboot (which is due to
> the
> megaraid driver crashing.  I have tried forcing the old megaraid driver in
> the
> kernel config and rebuilding but this has no effect.
> 
> Steps to reproduce:
> Run a system for a few days, crashes seem to occure around 3 am approx.
> The
> only other SCSI device on the system is a Dell DLT Drive.
> 
> This is a serious bug!
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
