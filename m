From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v6 0/7] ZPODD patches
Date: Thu, 13 Sep 2012 16:30:58 +0800
Message-ID: <505199C2.7070309@intel.com>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com> <7AD76063A97F48128F7F6B285CD05C7E@usish.com.cn> <505150F7.3040800@intel.com> <EA857C7C6FB245F1B2B3C82DEA6DA148@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37931 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab2IMIbQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Sep 2012 04:31:16 -0400
In-Reply-To: <EA857C7C6FB245F1B2B3C82DEA6DA148@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: 'Aaron Lu' <aaron.lwe@gmail.com>, 'Alan Stern' <stern@rowland.harvard.edu>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org

On 09/13/2012 04:15 PM, Jack Wang wrote:
>>> For hard disk runtime power off, Is there (hardware?) requirement for
> hard
>>> drive to support similar feature?
>>
>> No requirement for hard drive, as it does not need to remote wake up
>> itself while powered off.
>>
>> Please note that there is a v7 sent yesterday, you may want to take a
>> look at that instead of v6.
>>
>> And the runtime power off of hard drive is dropped from that patch set,
>> I'll submit it in another patch set(pretty small changes needed).
>>
>> Thanks,
>> Aaron
> [Jack Wang] Thanks Aaron for quick replay, for disk runtime power off, will
> it   a different proach from block runtime power management patch set from
> Lin Ming? 

I suppose you mean the "block layer runtime pm" from Lin Ming?
No, they are different things.

That patch set introduced a mechanism to decide when a device can enter
runtime suspend based on block layer request, while my patch cares about
when it is runtime suspended, how to remove its power.

Thanks,
Aaron
