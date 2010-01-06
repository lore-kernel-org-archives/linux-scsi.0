From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 14961] New: Very old and buggy ARCMSR drivers are included
Date: Wed, 6 Jan 2010 15:20:30 -0800
Message-ID: <20100106152030.fdf71c56.akpm@linux-foundation.org>
References: <bug-14961-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932593Ab0AFXWI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2010 18:22:08 -0500
In-Reply-To: <bug-14961-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, mikki@hugo.dk, Nick Cheng <nick.cheng@areca.com.tw>

On Wed, 30 Dec 2009 12:38:06 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14961
> 
>            Summary: Very old and buggy ARCMSR drivers are included
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 2.6.18 etc
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: mikki@hugo.dk
>         Regression: No
> 
> 
> Created an attachment (id=24377)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=24377)
> Latest arcmsr
> 
> Hello,
> 
> Some very buggy ARCMSR drivers are included in the kernels dating from early
> 2008.
> 
> The new drivers with the same version number, but a later date exists and
> should be included instead.
> 
> This is the latest
> ftp://ftp.areca.com.tw/RaidCards/AP_Drivers/Linux/DRIVER/SourceCode/arcmsr.1.20.0X.15-90605.zip
> 
> With the older .15 driver i had several system lockups under heavy load.
> 

Well that's bad.  I'm not seeing any commits against that driver from
Areca staff since February 2008.

So it may be that the manufacturer has abandoned this driver.  If so,
then it would be useful if someone who has the hardware could pick
apart the differences between the above driver and the in-kernel
version, and send the updates into the mainline kernel.

