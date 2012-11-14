From: "Jason J. Herne" <hernejj@gmail.com>
Subject: Re: [PATCH] Try #2: Use SCSI read/write(16) with >2TB drives
Date: Wed, 14 Nov 2012 17:06:06 -0500
Message-ID: <CAJiM5SZ=b5P5L5iT062GE+TbfUQOafo5YcMWOKTfvwJMYuxjig@mail.gmail.com>
References: <1352872513-2424-1-git-send-email-hernejj@gmail.com>
	<20121114190214.GD6439@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34663 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085Ab2KNWGG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Nov 2012 17:06:06 -0500
In-Reply-To: <20121114190214.GD6439@breakpoint.cc>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, JBottomley@parallels.com, Alan Stern <stern@rowland.harvard.edu>

On Wed, Nov 14, 2012 at 2:02 PM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> On Wed, Nov 14, 2012 at 12:55:13AM -0500, Jason J. Herne wrote:
>>               }
>>       }
>>
>> +     /* Use read/write(16) for > 2TB disks */
>> +     sdp->use_16_for_rw = (sdkp->capacity > 0xffffffff);
>
> The comment is pointless if you assume the reading is able to read C. What
> would help is a link either here or in patch's description to the mail thread
> where it has been descovered that some >2TB devices don't recognize the small
> command.

I've removed the comment entirely and added a link to the original
post within the patch
description. Resending in separate e-mail.

--
- Jason J. Herne (hernejj@gmail.com)
