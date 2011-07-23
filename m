From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 08/13] iscsi-target: Add CHAP Authentication support using libcrypto
Date: Sat, 23 Jul 2011 10:51:08 -0700
Message-ID: <CA+55aFzkEUbnoDg0KwXDRQMeCFeO5s6_4dWHTY59=hj3QHWL0w@mail.gmail.com>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
 <1311410747-29947-9-git-send-email-nab@linux-iscsi.org> <1311439173.23720.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730Ab1GWRvb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2011 13:51:31 -0400
In-Reply-To: <1311439173.23720.14.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andrew Morton <akpm@linux-foundation.org>

On Sat, Jul 23, 2011 at 9:39 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> I've asked you twice for input on the patch doing this in userspace,
> which was posted five weeks ago. =A0Just ignoring something is
> unacceptable behaviour ... what do I have to do to get your attention=
?
> NAK the patch set?

So what's the advantage of user space?

Traditionally, kernel/userspace splits have been:
 - fragile as hell
 - more code
 - slower
 - complicated to set up
 - problematic with backwards compatibility issues
and these days when I see some kernel functionality that needs user
space support, I just go "f*ck, that's going to be a pain".

So I think the "that part can be done in user space" argument is
fundamentally crap.

Now, if it is an issue of "that can be done BETTER in user space
BECAUSE xyz", then that's a different issue. I haven't seen that
argument, though.

                       Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
