From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 12119] iscsi repeatedly times out
Date: Mon, 01 Dec 2008 10:19:56 -0600
Message-ID: <49340EAC.1020300@cs.wisc.edu>
References: <20081201133958.2C4EA10800D@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50359 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbYLAQUL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2008 11:20:11 -0500
In-Reply-To: <20081201133958.2C4EA10800D@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12119
> 
> 
> 
> 
> 
> ------- Comment #3 from ian@beware.dropbear.id.au  2008-12-01 05:39 -------
> Thanks. The patch wouldn't apply but I applied it by hand. It works fine.

Ok. I will submit a patch. Thanks for the report and testing.


> 
> I didn't know about the CONFIG_SYSFS_DEPRECIATED options. Unfortunately I can't
> upgrade to FC9 or FC10 because of a kernel nfs bug(s) [11061,11154]. I'm not
> sure if I could run FC10 with an older kernel, but things like the changes to
> sysfs shows it is best not to assume so!
> 

I did not mean to upgrade to all F10 or F9 - just the iscsi package in 
there. The code across them is the same more or less. F9 and F8 were the 
same for iscsi, so if you use:

http://mirrors.kernel.org/fedora/updates/9/x86_64.newkey/iscsi-initiator-utils-6.2.0.870-1.0.fc9.x86_64.rpm

(for i386 or ppc then swap the x86_64 refs for your arch) on F8 then you 
should be ok.
