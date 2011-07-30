From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [GIT PULL-v2] iscsi-target merge for v3.1-rc1
Date: Sat, 30 Jul 2011 11:30:30 +0200
Message-ID: <CAO+b5-okX7BTMyf832g3uP0ghr9MMd-hNz4AVj2An8eVDMHE1Q@mail.gmail.com>
References: <1311732839.10646.132.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46718 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1G3Jav (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jul 2011 05:30:51 -0400
In-Reply-To: <1311732839.10646.132.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, Jul 27, 2011 at 4:13 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Here is an updated pull request for an initial v3.1-rc1 merge of
> iscsi_target including the updates to address some recent build breakage
> with iscsi_proto.h in linux-next, and minor build warnings on 32-bit.

Hi Linus, Andrew and James,

There is a tradition in the Linux kernel community of only accepting
kernel code upstream after all major outstanding issues have been
resolved. Something that I consider as a major outstanding issue and
that does not only affect the iSCSI target code but also the target
core is that support for hot-pluggable HCAs is missing. This is
something I have reported more than once in the past -- see e.g.
http://www.spinics.net/lists/linux-scsi/msg50248.html. As far as I
know nobody is working on this. So I'm wondering whether that has
perhaps been overlooked when the iSCSI target code was pulled ?

Bart.
