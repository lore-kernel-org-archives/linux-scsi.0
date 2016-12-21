From: Oliver Neukum <oneukum@suse.com>
Subject: Re: JMS56x not working reliably with uas driver
Date: Wed, 21 Dec 2016 12:42:27 +0100
Message-ID: <1482320547.7638.7.camel@suse.com>
References: <585A69E6.6040009@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751463AbcLULsv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Dec 2016 06:48:51 -0500
In-Reply-To: <585A69E6.6040009@caviumnetworks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: George Cherian <gcherian@caviumnetworks.com>
Cc: hdegoede@redhat.com, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, 2016-12-21 at 17:09 +0530, George Cherian wrote:
> Hi Oliver,
> 
> I was working with this JMicron device and using the uas driver.
> I am seeing the following 2 issues.
> 
> 1) On connect I see the following messages.

Thanks. Do you want to submit it to Greg?
The patch is fine.

> 2) On disconnect I am seeing the following issue
> 
>   scsi host4: uas_post_reset: alloc streams error -19 after reset
>   sd 4:0:0:0: [sdb] Synchronizing SCSI cache
> 
> This is more fatal because after these messages the USB port becomes 
> unusable. Even an lsusb invocation hangs for ever.

Ouch. That points to a logic error. We should not reset if
a device is gone.
Could you send dmesg of such a case?

	Regards
		Oliver


