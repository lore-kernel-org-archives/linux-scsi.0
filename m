From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14961] Very old and buggy ARCMSR drivers are included
Date: Wed, 6 Jan 2010 23:21:56 GMT
Message-ID: <201001062321.o06NLu6g025884@demeter.kernel.org>
References: <bug-14961-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58571 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab0AFXV5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2010 18:21:57 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o06NLuej025886
	for <linux-scsi@vger.kernel.org>; Wed, 6 Jan 2010 23:21:56 GMT
In-Reply-To: <bug-14961-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14961





--- Comment #1 from Andrew Morton <akpm@linux-foundation.org>  2010-01-06 23:21:38 ---
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
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24377)
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

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
