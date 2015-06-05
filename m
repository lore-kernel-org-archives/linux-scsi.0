From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH v3] fusion: remove dead MTRR code
Date: Fri, 5 Jun 2015 17:17:08 +0530
Message-ID: <CAK=zhgqM3YM45=jYvhJkmFC-9TFBXDaeGXq1gcjERbFjmTxWVg@mail.gmail.com>
References: <1429649166-18294-1-git-send-email-mcgrof@do-not-panic.com>
	<CAK=zhgqU7+Dm1ZUhVpGF_QMPAPnnaSbdh18GLajDvJBAXrGCQg@mail.gmail.com>
	<20150604174134.GQ23057@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33267 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbbFELrJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2015 07:47:09 -0400
Received: by wgez8 with SMTP id z8so54757340wge.0
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2015 04:47:08 -0700 (PDT)
In-Reply-To: <20150604174134.GQ23057@wotan.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <JBottomley@parallels.com>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Andy Lutomirski <luto@amacapital.net>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, mst@redhat.com, Toshi Kani <toshi.kani@hp.com>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Antonino Daplas <adaplas@gmail.c>

On Thu, Jun 4, 2015 at 11:11 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Thu, Jun 04, 2015 at 10:20:23AM +0530, Sreekanth Reddy wrote:
>> Hi Luis,
>>
>> Sorry for delay in response. Actually I was looking for the history of
>> this section of code but I couldn't find it. Anyway this is dead code
>> and we are fine with removing this dead code.
>>
>> James,
>>
>> Please consider this patch as:
>>
>> Acked-by: Sreekanth Reddy <ureekanth.reddy@avagotech.com>
>
> Great thanks, now who's tree should this patch go through? Last patch for this
> driver was in 2014 and went through Christoph, but if Christoph doesn't want to
> take it can it go through Andrew's tree?
>
> Sreekanth, can you also update the MAINTAINERS file to reflect recent changes
> at your company ?

Sure I will do this.

>
>   Luis

Thanks,
Sreekanth
