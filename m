From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11804] iscsi: LRO plus iSCSI causes panic
Date: Thu,  6 Nov 2008 16:08:49 -0800 (PST)
Message-ID: <20081107000849.349F6108047@picon.linux-foundation.org>
References: <bug-11804-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbYKGAJV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 19:09:21 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA708n6o017391
	for <linux-scsi@vger.kernel.org>; Thu, 6 Nov 2008 16:08:50 -0800
In-Reply-To: <bug-11804-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11804





------- Comment #2 from jesse.brandeburg@intel.com  2008-11-06 16:08 -------
Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via
> the bugzilla web interface).

This panic is still unaddressed.  Can I provide more information?




> (I'll reassign this to scsi).
> 
> On Tue, 21 Oct 2008 17:17:03 -0700 (PDT)
> bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=11804
>> 
>>            Summary: iscsi: LRO plus iSCSI causes panic
>>            Product: Networking
>>            Version: 2.5
>>      KernelVersion: 2.6.26
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: Other
>>         AssignedTo: acme@ghostprotocols.net
>>         ReportedBy: jesse.brandeburg@intel.com
>> 
>> 
>> Distribution: SuSE SLES 10.2
>> Hardware Environment:
>> .config is available on request, we are using i686 arch, dell 2950,
>> ixgbe adapter, inet_lro module. 
>> 
>> Software Environment: none/gnome-session running yast2
>> 
>> Problem Description:
>> We found that just trying to connect with no authentication to an
>> iSCSI 
>> target over an adapter running either the in-kernel LRO or an
>> in-driver version will cause this panic.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
