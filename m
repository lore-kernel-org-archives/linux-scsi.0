From: Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: Re: [RESEND PATCH v3] scsi: stex: Remove use of struct timeval
Date: Fri, 30 Oct 2015 01:54:10 -0700
Message-ID: <CAB__kk=s_axDoU4PBr0_6ME+1TTYD_D4+u=t9Vaq9+uMWtazPA@mail.gmail.com>
References: <20151030083040.GA31741@tina-laptop>
	<1446195000.16404.55.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:34226 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759126AbbJ3IyL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 04:54:11 -0400
In-Reply-To: <1446195000.16404.55.camel@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@odin.com>, y2038@lists.linaro.org, Linux Kernel List <linux-kernel@vger.kernel.org>

>
> Thanks for the conversion. Can you please check if other (scsi) drivers
> have the same y2038 issues? A quick "git grep do_gettimeofday
> drivers/scsi/  | wc -l" reveals 30 occurrences (of cause not all are
> problematic).
>

Hi Johannes,
Yes, there are quite a few occurrences of timeval within scsi. I had
sent some of the trivial back in the Feb-May 2015 period, and they
were ack-ed by my then mentor and a couple of other people, but not
merged or ack-ed by someone from linux-scsi. Until today, I thought
using "RESEND" would be impolite, but now I will resend the other ones
as well. Arnd Bergmann is leading this effort and may have more
insightful comments.
Thanks,
Tina
