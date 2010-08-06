From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] fnic: do not reset dev_loss_tmo in slave callout
Date: Fri, 06 Aug 2010 11:32:38 -0500
Message-ID: <4C5C3926.4030105@cs.wisc.edu>
References: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-3-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-4-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-5-git-send-email-michaelc@cs.wisc.edu> <4C5C24F7.3050403@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42197 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761272Ab0HFQ2i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 12:28:38 -0400
In-Reply-To: <4C5C24F7.3050403@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, James.Smart@Emulex.Com, brking@us.ibm.com

On 08/06/2010 10:06 AM, Joe Eykholt wrote:
> On 8/6/10 1:02 AM, michaelc@cs.wisc.edu wrote:
>> From: Mike Christie<michaelc@cs.wisc.edu>
>>
>> This fixes a bug where the driver was resetting the
>> rport dev_loss_tmo when devices were added by adding
>> support for the get_host_def_dev_loss_tmo callout.
>
> fnic devloss timeout isn't settable on the host.
> It's only configurable from network configuration.
> So, I think this patch is unnecessary.
>
> Note that we don't have a set method, so the
> /sys file will be read-only.

Ah yeah, I see that now. I argee it is not needed to fix the bug I was 
fixing. It might be nice to have it, so drivers are setting the dev loss 
tmo in the same way though. It does not matter to me either way though.
