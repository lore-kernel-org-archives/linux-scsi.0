From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] fusion: streamline ->queuecommand
Date: 06 Oct 2004 10:47:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097077662.1949.37.camel@mulgrave>
References: <BC3CE0375D29D51199A400508B66CA6C0862AEFE@exc-snake.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:38820 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269300AbUJFPsR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2004 11:48:17 -0400
In-Reply-To: <BC3CE0375D29D51199A400508B66CA6C0862AEFE@exc-snake.co.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Gibbons, Terry" <Terry.Gibbons@lsil.com>
Cc: "'arjanv@redhat.com'" <arjanv@redhat.com>, Eric Dean Moore <Emoore@lsil.com>, "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-10-06 at 09:23, Gibbons, Terry wrote:
> Maybe we should change the focus. What are your suggestions for making sure
> that every major server vendor isn't negatively impacted by changes to DV? 

Well, since every statment from you and your engineers is that you
haven't looked through the generic DV code, I suggest you do so if you
want to participate meaningfully in the discussion.  Saying point blank
you won't use any replacement whatever it looks like is hardly conducive
to a measured debate.

After you look through it, any technical criticisms or requests for
missing features would be welcome.

You appear to be assuming that you can't suggest changes to the generic
DV code, which isn't the case.  The object of making the code generic is
to avoid all the pitfalls that the other drivers fell into trying to
roll their own while creating the best code for all of them.

As has been said before no-one gets a veto on open source code.  Your
choice is either to participate in the evolution of the SCSI subsystem
or not to.  However, the evolution will continue, whatever you decide.

The thing I know it's hardest to appreciate, coming from the computing
industry myself, is that maintaining a driver doesn't just make you
responsible for that driver alone but also for improving the subsystem
it sits in and the rest of the kernel that surrounds it.  If you find a
bug, it's always tempting to apply a workaround to your driver when what
is really needed is a fix for the subsystem itself.  However, in
exchange for thinking of the kernel and the subsystem as well as just
your driver you get a genuine franchise in how the kernel and the
subsystem evolve ... most industry maintainers find that to be more than
worth the extra effort.

James


