From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Wed, 25 Feb 2015 09:43:36 +0100
Message-ID: <54ED8B38.10904@sandisk.com>
References: <54B63F74.2040702@sandisk.com>
	 <20150115090829.GA14154@infradead.org> <54B7E70C.8020304@sandisk.com>
	 <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com>
	 <54E7112F.2080901@sandisk.com>
 <1424476807.1477.52.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0093.outbound.protection.outlook.com ([157.56.110.93]:48096
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753388AbbBYInp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2015 03:43:45 -0500
In-Reply-To: <1424476807.1477.52.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/21/15 01:00, Nicholas A. Bellinger wrote:
> On Fri, 2015-02-20 at 11:49 +0100, Bart Van Assche wrote:
>> What I proposed myself consists of three steps:
>> 1. Updating the LIO SRP target driver to a more recent version.
>> 2. Target driver and LIO core refactoring such that the LIO and
>>    SCST APIs can be unified.
>> 3. Adding support in SCST for the unified target driver API.
>>
>> This work is taking a little more time than I had expected - I still
>> have to start with step (3). But I can already show in which direction I
>> would like to go for steps (1) and (2). The 43 patches I came up with so
>> far for steps (1) and (2) are available in the lio branch of the
>> https://github.com/bvanassche/linux git repository. As you can see in
>> that repository 42 of these 43 patches make sense even without knowing
>> that something like SCST exists.
> 
> Please go ahead and post the series for review with bug fixes at the
> head of the series, with future improvements following after the fixes.
> 
> Doing a brief review from your tree, I can see there are some useful
> fixes, but also there are some patches that have incorrect assumptions
> and/or break the existing userspace APIs.
> 
> That said, I'm happy to review the full series, and very much appreciate
> your efforts to improve upstream code.
> 
> However, keep in mind that I'll not be merging anything for target-core
> that adds support for out-of-tree code, nor anything that changes
> existing target configfs APIs to fit out-of-tree code requirements.

Let's start with what we agree on and discuss the other topics during
the LSF/MM summit. I just sent one patch of that series to the
linux-scsi mailing list for review.

Bart.

