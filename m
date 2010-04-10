From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15688] mptsas & poor performance
Date: Sat, 10 Apr 2010 16:58:43 GMT
Message-ID: <201004101658.o3AGwhrZ015188@demeter.kernel.org>
References: <bug-15688-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56994 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab0DJQ66 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2010 12:58:58 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3AGwkep015211
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2010 16:58:46 GMT
In-Reply-To: <bug-15688-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15688





--- Comment #6 from Brian Sullivan <bexamous@gmail.com>  2010-04-10 16:57:26 ---
BTW, I did not look into this as much, but using 3.xx there also seemed to
be a limit of ~600MB/sec between controller & expander.  If I put two arrays
on the expander, each array by itself would do almost 500MB/sec in reads,
but together they couldn't break 600MB/sec.  I didn't really look into this
further, maybe I was doing something wrong.  ~600MB/sec, however, seems like
exactly 1/2 the bandwidth of the minisas cable between controlller &
expander.


On Sat, Apr 10, 2010 at 5:00 AM, <bugzilla-daemon@bugzilla.kernel.org>wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=15688
>
>
>
>
>
> --- Comment #5 from dujun@perabytes.com  2010-04-10 12:00:53 ---
> Hi Andrew & Kashyap,
>
> It seems to me that the 4.22.00.00 driver from lsi is much faster than
> kernel
> 3.xx version driver.  We have 16 WD SATA disks connected through lsi sas
> expander to 1068e hba and linux md raid5 using these disks. The system has
> only
> one quad-core E5405 CPU.  With the new lsi driver, we get sequential dd
> read
> performance up to 795MB/s and write performance up to 395MB/s which is
> almost
> twice as the kernel 3.xx driver.
>
> We will investigate different hardware setup further and let u know as soon
> as
> possible.
>
> Johnson
>
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You reported the bug.
>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
