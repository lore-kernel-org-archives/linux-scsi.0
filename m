From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] scsi/bfa: use designated initializers
Date: Wed, 12 Apr 2017 17:21:20 -0700
Message-ID: <CAGXu5jJ+9nm+Ojxfkc7z=y1=arSCh8Ye=aTXbvZHQwOwcrFgLA@mail.gmail.com>
References: <20170329205509.GA39525@beast> <20170330081855.GA11344@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36575 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755129AbdDMAVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2017 20:21:21 -0400
Received: by mail-io0-f179.google.com with SMTP id l7so61097951ioe.3
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 17:21:21 -0700 (PDT)
In-Reply-To: <20170330081855.GA11344@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Mar 30, 2017 at 1:18 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Mar 29, 2017 at 01:55:09PM -0700, Kees Cook wrote:
>> Prepare to mark sensitive kernel structures for randomization by making
>> sure they're using designated initializers. These were identified during
>> allyesconfig builds of x86, arm, and arm64, with most initializer fixes
>> extracted from grsecurity.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> This has been updated now that struct bfa_fcs_mod_s was dropped.
>
> Can you also add designated array initializers for __port_action while
> you're at it?

Hrm? This is what the patch already does. It adds them for both
__port_action and struct bfa_module_s.

-Kees

-- 
Kees Cook
Pixel Security
