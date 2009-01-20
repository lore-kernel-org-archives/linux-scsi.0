From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi tcp: bidi capable
Date: Tue, 20 Jan 2009 13:36:09 -0600
Message-ID: <497627A9.2020004@cs.wisc.edu>
References: <4975D96A.6020407@panasas.com> <4975E423.2020506@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55233 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbZATTg3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2009 14:36:29 -0500
In-Reply-To: <4975E423.2020506@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Pete Wyckoff <pw@padd.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Boaz Harrosh wrote:
> Boaz Harrosh wrote:
>> From: Pete Wyckoff <pw@padd.com>
>>
>> Mark iscsi_tcp as being capable of bidirectional transfers.  The
>> bsg interface checks this bit before attempting any bidirectional
>> commands.
>>
>> Signed-off-by: Pete Wyckoff <pw@padd.com>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
> <snip>
> 
> Mike hi, whatever happened with this patch?
> 

I never saw it before. I must have missed it. I will queue it for the 
next feature window.
