From: John Huttley <John@mib-infotech.co.nz>
Subject: Re: [Bugme-new] [Bug 10567] New: tape/by-id/ nodes not creating due
 to scsi_id not returning serial number, st nst
Date: Mon, 28 Apr 2008 14:33:44 +1200
Message-ID: <48153788.1050509@mib-infotech.co.nz>
References: <bug-10567-10286@http.bugzilla.kernel.org/> <20080427184404.f0656d2c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.orcon.net.nz ([219.88.242.51]:44181 "EHLO mx1.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761451AbYD1C6i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2008 22:58:38 -0400
Received: from Debian-exim by mx1.orcon.net.nz with local (Exim 4.67)
	(envelope-from <John@mib-infotech.co.nz>)
	id 1JqJBe-0005yN-BO
	for linux-scsi@vger.kernel.org; Mon, 28 Apr 2008 14:33:50 +1200
In-Reply-To: <20080427184404.f0656d2c.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Thanks,
Hi Patrick

I'm happy to have any help.

Regards,

John


Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Sun, 27 Apr 2008 15:13:41 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=10567
>>
>>            Summary: tape/by-id/ nodes not creating due to scsi_id not
>>                     returning serial number, st nst
>>            Product: Drivers
>>            Version: 2.5
>>      KernelVersion: 2.6.25 and earlier, vanilla and gentoo alike, X64
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: HotPlug
>>         AssignedTo: greg@kroah.com
>>         ReportedBy: john@mib-infotech.co.nz
>>
>>
>> Latest working kernel version: unkn
>> Earliest failing kernel version:  unkn , but atleast 2.6.22
>> Distribution:  gentoo X64
>> Hardware Environment: HP ML150, sym53c8xx card, LTO-2 external tape
>> Software Environment: Gentoo, udev-120
>> Problem Description:
>> udev creates the tape/by-id/ nodes for st* device but fails with nst devices,
>> (or vs versa)
>>
>> (I WILL PUT THIS AS AN ATTACHMENT ALSO)
>>
>> The scsi_id program is returning no serial numbers in some cases.
> 
> This appears to be a bug report against the userspace scsi_id command.
> 
> According to the manpage, Patrick is the lucky duck ;)
> 
> 
