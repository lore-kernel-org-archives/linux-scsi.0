From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Fri, 22 Jan 2016 13:11:43 -0600
Message-ID: <56A27EEF.7060204@cs.wisc.edu>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com> <56A25DD7.5090700@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49070 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbcAVTL7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 14:11:59 -0500
In-Reply-To: <56A25DD7.5090700@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, mchristi@redhat.com, linux-scsi@vger.kernel.org
Cc: Guilherme Piccoli <gpiccoli@linux.vnet.ibm.com>, Or Gerlitz <ogerlitz@mellanox.com>, "gerlitz.or@gmail.com >> Or Gerlitz" <gerlitz.or@gmail.com>, Chris Leech <cleech@redhat.com>

On 01/22/2016 10:50 AM, Brian King wrote:
> On 11/11/2015 11:05 PM, mchristi@redhat.com wrote:
>> From: Mike Christie <mchristi@redhat.com>
>>
>> This patch fixes this oops report by Guilherme Piccol:
>>
>> list_del corruption. prev->next should be c000000f3da2b080, but was c000000f3da2c080
> 
> Hi Mike! I haven't seen any follow ups on this for a while. What is the plan for this one? 
> 

Hey,

I ended up sending Guilherme a patch for the problem I described here.
They were not hitting that problem. Checked if we were hitting a
different regression in the abort path. Not hitting that either.

Or was still debugging it.
