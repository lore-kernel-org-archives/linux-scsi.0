From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] target fixes for v4.11-rc3
Date: Sun, 19 Mar 2017 18:58:33 -0700
Message-ID: <CA+55aFxy7tAHqU4ihuRCyv9rzugcbS9c-RgL3_28UsGpuh92SQ@mail.gmail.com>
References: <1489889280.27336.80.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:38257 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752506AbdCTB6g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Mar 2017 21:58:36 -0400
In-Reply-To: <1489889280.27336.80.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Sat, Mar 18, 2017 at 7:08 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> Here are the target-pending fixes for v4.11-rc3 code.

So I'm very unhappy with how these patches were rebased or applied
just before the pull request.

I did my usual build test, but didn't notice how recent it all was
until after I had already pulled other things, so now I'm going to
just live with it, but you are now on  my shit-list.

All but two of the commits you sent me were committed just a few hours
before the pull request, and the qla series was done about 90m minutes
before. And some of the commits were new feature support.

Don't do this.

                 Linus
