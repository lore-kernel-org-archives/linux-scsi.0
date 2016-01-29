From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
Date: Thu, 28 Jan 2016 19:53:09 -0600
Message-ID: <56AAC605.1080707@cs.wisc.edu>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53056 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbcA2BxS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 20:53:18 -0500
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On 01/28/2016 04:51 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=111441
> 
>             Bug ID: 111441
>            Summary: iscsi fails to attach to targets
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 4.4.0-1
>           Hardware: x86-64
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW


> 4.4.0-1.el7.elrepo.x86_64 #1

I have not seen this oops before. We saw similar ones around 5 or 6
years ago, but they were due to some sysfs or block or scsi issue (I
cannot remember exacty) and fixed there.

Is this a distro kernel or mainline. BZ says mainline, but the kernel
name in bug looks like a red hat related one. Where did you get it?

I do not hit this in 4.4 mainline. Send me your kernel .config, so I can
make sure I have the same options.

