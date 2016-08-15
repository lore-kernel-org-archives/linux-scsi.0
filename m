From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [Bug 153171] New: scsi host6: runtime PM trying to activate child
 device host6 but parent (2-2:1.0) is not active
Date: Mon, 15 Aug 2016 22:04:16 +0200
Message-ID: <87520866-b206-c938-6cda-e2f1c9f85f6b@gmail.com>
References: <bug-153171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34784 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbcHOUEV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2016 16:04:21 -0400
Received: by mail-wm0-f68.google.com with SMTP id q128so12860717wma.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2016 13:04:20 -0700 (PDT)
In-Reply-To: <bug-153171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Am 15.08.2016 um 21:55 schrieb bugzilla-daemon@bugzilla.kernel.org:
> https://bugzilla.kernel.org/show_bug.cgi?id=153171
> 
>             Bug ID: 153171
>            Summary: scsi host6: runtime PM trying to activate child device
>                     host6 but parent (2-2:1.0) is not active
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 4.8.0-040800rc2-lowlatency
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>           Assignee: linux-scsi@vger.kernel.org
>           Reporter: caravena@gmail.com
>         Regression: No
> 
> Created attachment 228931
>   --> https://bugzilla.kernel.org/attachment.cgi?id=228931&action=edit
> dmesg_4.8.0-040800rc2-lowlatency
> 
> Mount USB Pendrive
> 
> dmesg:
> [ 4630.693915] scsi host6: runtime PM trying to activate child device host6 but
> parent (2-2:1.0) is not active
> 
This issue is fixed by patch scsi: "core: configure runtime pm before calling
device_add in scsi_add_host_with_dma" I sent on Aug 3rd.

Regards, Heiner

