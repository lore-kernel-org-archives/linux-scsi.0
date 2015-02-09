From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Mon, 9 Feb 2015 14:16:45 +0100
Message-ID: <54D8B33D.40509@sandisk.com>
References: <201502031006.t13A6KhM008961@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0086.outbound.protection.outlook.com ([207.46.100.86]:48384
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759464AbbBINQw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2015 08:16:52 -0500
In-Reply-To: <201502031006.t13A6KhM008961@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com, Christoph Hellwig <hch@infradead.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 02/03/15 11:06, Dr. Greg Wettstein wrote:
> On Jan 19,  1:21am, Christoph Hellwig wrote:
>> On Thu, Jan 15, 2015 at 05:13:00PM +0100, Bart Van Assche wrote:
>>> My goal is to realize this proposal without adding hooks for out-of-tree
>>> code in the upstream kernel. What I had in mind is to raise the
>>> abstraction level of the API between LIO core and target drivers a
>>> little bit (e.g. by using accessor functions where necessary instead of
>>> accessing structure members directly)
> 
>> That's very much a hook, althiugh a week one.
>>
>> Either way I don't think bringing up a very much political topic
>> without even any code to discuss isn't a very valueable use of our time
>> slots.
> 
> There is code, no one is bothering to look at it or understand the
> issues involved.
> 
> It takes a six line patch to the in-kernel Qlogic target driver for
> SCST to leverage and contribute positively to the state of the
> in-kernel driver.  A six line patch, which if we were engaging in
> grounded engineering discussions, implements an interface which we
> haven't found anyone who suggests is unfounded.

Hi Greg,

Thanks for your feedback. Although I certainly value your work, please
note that what I proposed goes further than what you have done. If I
understood your e-mails correctly what you have done is to unify the API
between the QLogic initiator and target drivers for SCST and LIO. My
proposal comprises not only a unification of the initiator drivers but
also of the target drivers.

Last week I finally found the time to start working on an sample
implementation of such a unified driver. I hope that I will be able to
make that code available for review somewhere next week.

Bart.

