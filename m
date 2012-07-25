From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] libata updates
Date: Wed, 25 Jul 2012 15:06:17 -0700
Message-ID: <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com>
References: <20120725203551.GA19762@havoc.gtf.org> <20120725204350.GA20530@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49089 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2GYWGj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2012 18:06:39 -0400
In-Reply-To: <20120725204350.GA20530@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Wed, Jul 25, 2012 at 1:43 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On Wed, Jul 25, 2012 at 04:35:51PM -0400, Jeff Garzik wrote:
>> Please pull 641589bff714f39b33ef1d7f02eaa009f2993b64 from
>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream
>>
>
> Oh, I forgot to point out the merge commit, making my HEAD more recent
> than might be expected.  There was a merge conflict and an API change
> that needed to be dealt with, in order for your pull to be correct.

So I'd *much* rather see an explanation of what the conflict is when
you ask me to pull, and let me handle it, rather than you pre-merging
things for me. I *want* to see conflicts between subsystems.
Seriously.

                   Linus
