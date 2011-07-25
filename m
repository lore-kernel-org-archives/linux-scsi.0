From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 08/13] iscsi-target: Add CHAP Authentication support	using
 libcrypto
Date: Mon, 25 Jul 2011 12:31:18 -0700
Message-ID: <4E2DC486.8080701@redhat.com>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>	 <1311410747-29947-9-git-send-email-nab@linux-iscsi.org>	 <1311439173.23720.14.camel@mulgrave>	 <CA+55aFzkEUbnoDg0KwXDRQMeCFeO5s6_4dWHTY59=hj3QHWL0w@mail.gmail.com>	 <1311445075.17423.13.camel@mulgrave>	 <1311455867.31450.287.camel@haakon2.linux-iscsi.org>	 <1311479558.2702.8.camel@mulgrave> <1311482486.31450.408.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab1GYTb3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2011 15:31:29 -0400
In-Reply-To: <1311482486.31450.408.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andrew Morton <akpm@linux-foundation.org>

On 07/23/2011 09:41 PM, Nicholas A. Bellinger wrote:
> While I apperciate Mike's input here, I'll leave the final word to Andy
> and Christoph who have been primarly driving iscsi-target v4.1
> development and are the guys who have their fingers deepest in the code.

I appreciate that, but hch and I have been working on cleaning up the
main datapath; I personally haven't needed to familiarize myself with
the auth code at all so far. That said, I happen to think you are
correct, and am in favor of accepting the code as is, with in-kernel
auth. I wasn't 100% sure from reading Mike's response but it sounded
like he was saying he'd be ok with in-kernel auth since it would make
handling hw iscsi targets easier.

(BTW I think the arguments about backwards compatibility with existing
rtslib or pre-kernel-acceptance versions are not persuasive and a
distraction from the real technical discussion. Linux has a very strong
stable-user-api tenet, but we should commit to support stable APIs that
are reviewed and accepted in the kernel, and not be limited by
compatibility with prior out-of-kernel versions.)

> But all that said, there is still one person who has the real final word
> here, and he's made it clear how he feels about this type of kernel/user
> split.

Well that's great and all - I would just emphasize we're all going to be
working on this code cooperatively for a long time to come. More time
spent discussing technical issues to where we can all reach a grumbling
consensus will ultimately bear more fruit than appeals to the Hierarchy.

Regards -- Andy
