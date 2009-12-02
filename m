From: Vineet Agarwal <checkout.vineet@gmail.com>
Subject: [PATCH 0/1] libosd bug fixing
Date: Wed, 2 Dec 2009 15:05:18 +0530
Message-ID: <425904320912020135m428b7eacwfabcaa3288dfff83@mail.gmail.com>
References: <4B15367C.9040405@panasas.com> <425904320912020131k46b34cdfmfa64a25196a5b44e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:59291 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZLBJfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2009 04:35:31 -0500
Received: by iwn1 with SMTP id 1so1606iwn.33
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2009 01:35:38 -0800 (PST)
In-Reply-To: <425904320912020131k46b34cdfmfa64a25196a5b44e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi Boaz,

On Tue, Dec 1, 2009 at 9:00 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>
> James hi.
>
> Users have found an annoying bug in latest osd/exofs code. Actually this
> deficiency exists for a long time, but only most recent exofs code has
> exposed it.
>
> Please include the fix to the patches queued for 2.6.33. No need for it
> to go into stable as current users will not hit it.
>
> [PATCH 1/1] libosd: Fix blk_put_request locking again
>
> Vineet Please test this new patch, the previous fix was crap

I applied the patch and it's working at my end.

>
> Thanks
> Boaz
>

-- 
Regards:
Vineet Agarwal
