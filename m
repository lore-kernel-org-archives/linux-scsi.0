From: bart@bartvanassche.be
Subject: Re: [PATCH 17/18] srp_transport: Add transport layer recovery
 support
Date: Tue, 17 Jul 2012 14:59:51 +0200
Message-ID: <4a60357d9f7cfd0ba691914d73dc5865.squirrel@www.bartvanassche.be>
References: <3109536.qySrY1Ts3e@asus> <2536946.Diyz1JQnfo@asus>
    <500490A5.7020202@cs.wisc.edu>
    <1342477710.25927.10.camel@frustration.ornl.gov>
Reply-To: bart@bartvanassche.be
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [178.239.52.149] ([178.239.52.149]:50273 "EHLO wimaserver10.be"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754034Ab2GQNSV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2012 09:18:21 -0400
In-Reply-To: <1342477710.25927.10.camel@frustration.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>

> On Mon, 2012-07-16 at 18:07 -0400, Mike Christie wrote:
>> On 01/14/2012 05:56 AM, Bart Van Assche wrote:
>> > Add the necessary functions in the SRP transport module to allow
>> > an SRP initiator driver to implement transport layer recovery.
>>
>> I was updating my iscsi dev loss patch when I saw this is still not
>> merged.
>
> Yes, I got part way into doing a rework of Bart's code before I got
> sidetracked on another project. Cognizant of the looming merge window,
> I'm desperately trying to get back to it.

I'll post the latest version of the patch series next Monday (I'm
traveling now). If you have any suggestions for improvements about the
patches themselves or the implemented algorithms, these are welcome.

Bart.

