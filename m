From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH v5 01/11] scsi: ufs: sysfs: attribute group for existing
 sysfs entries.
Date: Mon, 12 Feb 2018 10:31:52 +0100
Message-ID: <CAOFm3uFHiOm9nfM=PGcynDigJpxg3Ou3_j5kHf4xhbergc6JwQ@mail.gmail.com>
References: <1517933183-30892-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1517933183-30892-2-git-send-email-stanislav.nijnikov@wdc.com> <20180212010602.GC44666@jaegeuk-macbookpro.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33759 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933233AbeBLJcd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 04:32:33 -0500
Received: by mail-wm0-f67.google.com with SMTP id x4so7879586wmc.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Feb 2018 01:32:33 -0800 (PST)
In-Reply-To: <20180212010602.GC44666@jaegeuk-macbookpro.roam.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alex.lemberg@wdc.com, Russell King <rmk@armlinux.org.uk>, Christoph Hellwig <hch@infradead.org>, Thomas Gleixner <tglx@linutronix.de>

Dear Stanislav,

On Mon, Feb 12, 2018 at 2:06 AM, Jaegeuk Kim <jaegeuk@kernel.org> wrote:
> On 02/06, Stanislav Nijnikov wrote:
>> This patch introduces attribute group to show existing sysfs entries.
>>
>> Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

<snip>

>> --- /dev/null
>> +++ b/drivers/scsi/ufs/ufs-sysfs.c
>> @@ -0,0 +1,156 @@
>> +// SPDX-License-Identifier: GPL-2.0-only

I commend you for using license ids here. But there is an issue with
your attempt to use the latest and greatest license ids from SPDX:
GPL-2.0-only is not a documented license id in our doc [1]
Until this is updated (help welcomed including patching a few 10K+
files) , this should be GPL-2.0 instead to avoid confusion and keep
things homogeneous and tidy.

FYI, using only the doc as the reference was brought forward by
Russell King and Christoph Hellwig and in particular with this:

On Thu, Nov 9, 2017 at 5:44 PM, Russell King <rmk@armlinux.org.uk> wrote:

> I'd be more comfortable if we could have something in the kernel tree
> that identifies the SPDX tags and their meaning, maybe with the
> _standard_ file header for that license included, so there is no
> argument about what any particular SPDX tag means.

Based on this, Thomas Gleixner updated the doc alright following this
important point. So, in case of doubt the doc should be the reference
for this and nothing else. And if there are issue with the doc, then
we can fix it with a patch ;)

CC: Russell King <rmk@armlinux.org.uk>
CC: Christoph Hellwig <hch@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/license-rules.rst
-- 
Cordially
Philippe Ombredanne
