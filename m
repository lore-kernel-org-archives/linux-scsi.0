From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Driver 'sd' needs updating
Date: Tue, 24 Mar 2009 17:33:02 +0200
Message-ID: <49C8FD2E.2060209@panasas.com>
References: <20090324141428.31E5118C7A3@pentland.suse.de> <49C8F186.2080705@panasas.com> <49C8F5C0.7030308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:29453 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752705AbZCXPel (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 11:34:41 -0400
In-Reply-To: <49C8F5C0.7030308@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
>>>  #endif /* _SCSI_SCSI_DRIVER_H */
>> I did not test this patch with osd_uld yet, but I will tomorrow. If my assumption
>> is right then drv-core should call my osd_remove just the same, right?
>>
> Yes, correct.
> 
>> Are there any different timing issue for example the presence of scsi_device
>> is still true?
>>
> No. Or rather, none you'll notice. (We're effectively saving on indirection here,
> but I doubt it'll be measureable)
> 
> Cheers,
> 
> Hannes

Thanks, I've patched my testing Kernel, and am scheduled to run tests later
tonight. I'm sure it will all work nicely minus the warning on load.

Thanks for doing this
Boaz
