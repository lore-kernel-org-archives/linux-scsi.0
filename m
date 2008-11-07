From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: RE: [Bugme-new] [Bug 11804] New: iscsi: LRO plus iSCSI causes panic
Date: Thu, 6 Nov 2008 16:08:08 -0800
Message-ID: <F169D4F5E1F1974DBFAFABF47F60C10A0E9DB65A@orsmsx507.amr.corp.intel.com>
References: <bug-11804-10286@http.bugzilla.kernel.org/>
 <20081021172721.027d9e1c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59508 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbYKGAIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 19:08:17 -0500
In-Reply-To: <20081021172721.027d9e1c.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
Cc: "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>

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

