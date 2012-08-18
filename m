From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 17/18] srp_transport: Add transport layer recovery support
Date: Sat, 18 Aug 2012 10:50:01 +0000
Message-ID: <502F7359.8020403@acm.org>
References: <3109536.qySrY1Ts3e@asus> <2536946.Diyz1JQnfo@asus>  <500490A5.7020202@cs.wisc.edu> <1342477710.25927.10.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:50867 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab2HRKuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Aug 2012 06:50:08 -0400
In-Reply-To: <1342477710.25927.10.camel@frustration.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 07/16/12 22:28, David Dillow wrote:
> On Mon, 2012-07-16 at 18:07 -0400, Mike Christie wrote:
>> On 01/14/2012 05:56 AM, Bart Van Assche wrote:
>>> Add the necessary functions in the SRP transport module to allow
>>> an SRP initiator driver to implement transport layer recovery.
>>
>> I was updating my iscsi dev loss patch when I saw this is still not merged.
> 
> Yes, I got part way into doing a rework of Bart's code before I got
> sidetracked on another project. Cognizant of the looming merge window,
> I'm desperately trying to get back to it. 
> 
>> Not sure about the ping code, but I think the dev loss tmo and fast io
>> fail related stuff should go to scsi_transport_template. We can then add
>> some common code to start the timers/delayed_work_queues, stop them,
>> set/get the value from sysfs, etc that all the transport classes can
>> then call.
> 
> Good idea, I'll look into doing this as part of it.

(replying to an e-mail of one month ago)

Hello Dave,

Have you already been able to make some progress with this work ? If the
patches for moving the shared parts of dev_loss_tmo / fast_io_fail_tmo
handling from scsi_transport_fc to scsi_transport_template would be
available in a reasonable timeframe I could adapt my ib_srp patch series
to take advantage of that work.

Bart.

