From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
Date: Thu, 28 Jan 2016 20:13:36 -0600
Message-ID: <56AACAD0.30705@cs.wisc.edu>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
 <56AAC605.1080707@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53073 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbcA2CNo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 21:13:44 -0500
In-Reply-To: <56AAC605.1080707@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, sbezverk@cisco.com

I thought you could just reply to kernel bugzilla mails and it would
automatically add your reply to the bz, but I got some errors. Ccing the
bug reporter here, so I do not have to make an account and go through bz.

Serguei see below. I need some extra info.

On 01/28/2016 07:53 PM, Mike Christie wrote:
> On 01/28/2016 04:51 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=111441
>>
>>             Bug ID: 111441
>>            Summary: iscsi fails to attach to targets
>>            Product: IO/Storage
>>            Version: 2.5
>>     Kernel Version: 4.4.0-1
>>           Hardware: x86-64
>>                 OS: Linux
>>               Tree: Mainline
>>             Status: NEW
> 
> 
>> 4.4.0-1.el7.elrepo.x86_64 #1
> 
> I have not seen this oops before. We saw similar ones around 5 or 6
> years ago, but they were due to some sysfs or block or scsi issue (I
> cannot remember exacty) and fixed there.
> 
> Is this a distro kernel or mainline. BZ says mainline, but the kernel
> name in bug looks like a red hat related one. Where did you get it?
> 
> I do not hit this in 4.4 mainline. Send me your kernel .config, so I can
> make sure I have the same options.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

