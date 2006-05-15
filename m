From: Jes Sorensen <jes@sgi.com>
Subject: Re: qla1280: failing mbox check
Date: 15 May 2006 05:13:34 -0400
Message-ID: <yq0r72vps5d.fsf@jaguar.mkp.net>
References: <446409CA.2090100@gentoo.org> <yq04pzvr9dz.fsf@jaguar.mkp.net>
	<4464888A.1000807@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:52687 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S1750792AbWEOJNf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 May 2006 05:13:35 -0400
In-Reply-To: <4464888A.1000807@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kumba <kumba@gentoo.org>
Cc: linux-scsi@vger.kernel.org

>>>>> "Kumba" == Kumba  <kumba@gentoo.org> writes:

Kumba> Jes Sorensen wrote:
>> 'git bisect' is your friend here.  Cheers, Jes

Kumba> That was the answer I was afraid of....  Already tried using
Kumba> git bisect to track down a bootmem allocation bug in SGI O2
Kumba> systems (2.6.17 just broke everything it seems...), but the
Kumba> bisection point happened to be around the time when all the
Kumba> bitops changes were occuring (moving duplicate functions from
Kumba> asm-mips -> asm-generic), resulting in a tree that wouldn't
Kumba> even compile.

Kumba> Having to patch up a broken tree so it even builds to determine
Kumba> if the bisection is good or bad might obscure the bug, but
Kumba> well, guess that's something to try on the weekend.

Uh oh!, bitops changing half way? Maybe the thing to try first is to
revert all the bitops mangling.

Kumba> Offhand, though, is there anything I should keep an eye out for
Kumba> that can do things like setting mb[] to 0x0 (i.e., things you
Kumba> guys might've seen happen in the past?).  And what do those
Kumba> numbers for 'mailbox0', 'ictrl', and 'istatus' mean (I'm
Kumba> guessing not much, because they're probably qla1040-specific
Kumba> error codes that require chip docs to understand).

I believe ICTRL == interrupt control, ISTATUS == interrupt
status. Don't have the docts in front of me though.

Cheers,
Jes
