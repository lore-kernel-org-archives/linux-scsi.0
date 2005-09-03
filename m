From: "Brown, Len" <len.brown@intel.com>
Subject: RE: 2.6.13-mm1: hangs during boot ...
Date: Sat, 3 Sep 2005 01:37:07 -0400
Message-ID: <F7DC2337C7631D4386A2DF6E8FB22B30047FA063@hdsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr13.intel.com ([192.55.52.67]:7079 "EHLO
	fmsfmr001.fm.intel.com") by vger.kernel.org with ESMTP
	id S1161146AbVICFhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Sep 2005 01:37:20 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

 
>Brown, Len wrote:
>>>>[  279.662960]  [<c02d5c74>] wait_for_completion+0xa4/0x110
>> 
>> 
>> possibly a missing interrupt?
>> 
>> 
>>>CONFIG_ACPI=y
>> 
>> 
>> any difference if booted with "acpi=off" or "acpi=noirq"?
>
>Yes.  In both cases, the system appears to boot normally but 
>I'm unable 
>to login or connect via ssh.  Also there's a "device not 
>ready" message 
>after the scsi initialization which I don't normally see.  
>I've attached 
>the scsi initialization output.  The PF_NETLINK error messages 
>after the 
>login prompt in this output are created whenever I try to log in or 
>connect via ssh.

Please confirm that vanilla 2.6.13 has none of these symptoms.
Please apply just the ACPI part of the 2.6.13-mm1 patch to see if
these issues are caused by that or if they are caused by something
else in the mm patch.

http://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.13/2.6.13-mm1/broken-out/git-acpi.patch

thanks,
-Len
