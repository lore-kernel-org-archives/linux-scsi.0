From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Tue, 26 Jul 2011 13:14:03 +0300
Message-ID: <CACVxJT-bP-2xSnPZxtP0QtLdGW1vaxTDGzr0WLLFR+wMqaQ9Wg@mail.gmail.com>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
	<20110725163739.5c19b04d.akpm@linux-foundation.org>
	<20110725165057.9701f16b.akpm@linux-foundation.org>
	<1311663071.17766.230.camel@haakon2.linux-iscsi.org>
	<CA+55aFyNBaf2+=XJDLKNF1S5zMtpx38+Zd8uNd9k4ap4YpZmvw@mail.gmail.com>
	<20110726100804.GA6069@dspnet.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49438 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1GZKOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 06:14:05 -0400
In-Reply-To: <20110726100804.GA6069@dspnet.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olivier Galibert <galibert@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Morton <akpm@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

On Tue, Jul 26, 2011 at 1:08 PM, Olivier Galibert <galibert@pobox.com> =
wrote:
> On Tue, Jul 26, 2011 at 12:09:40AM -0700, Linus Torvalds wrote:
>> And it just looks unnecessarily complicated. Just a simple
>>
>> #define DIV_ROUND_UP_ULL(ll,d) \
>> =A0 ({ unsigned long long _tmp =3D (ll)+(d)-1; do_div(_tmp, d); _tmp=
; })
>>
>> looks like it would work and be simpler. Avoid the conditional, do t=
he
>> same "add 'd-1' thing as the regular ROUND_UP().
>>
>> Untested. And not much thinking involved.
>
> Overflow risk? =A0Of course DIV_ROUND_UP has the same issue, and look=
s
> slight easier to trigger, maybe.

Can we please make DIV_ROUND_UP to demultiplex based on argument type i=
nside?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
