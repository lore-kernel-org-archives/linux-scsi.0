From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] Next round of SCSI updates for 3.2 merge window
Date: Tue, 10 Jan 2012 13:12:06 -0600
Message-ID: <1326222726.3264.41.camel@dabdike.int.hansenpartnership.com>
References: <1325801944.2775.32.camel@dabdike.Larkspurhotels.com>
	 <CA+55aFzR7Qvhoo9QVy-0RzPkqQ=J-DBpLurYSV7azMbQGOJchg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57728 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756664Ab2AJTMJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2012 14:12:09 -0500
In-Reply-To: <CA+55aFzR7Qvhoo9QVy-0RzPkqQ=J-DBpLurYSV7azMbQGOJchg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2012-01-10 at 10:36 -0800, Linus Torvalds wrote:
> On Thu, Jan 5, 2012 at 2:19 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > The patch is available here:
> >
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git#scsi-misc
> 
> No it's not.
> 
> Please fix your crappy script.
> 
> First off, that '#' is wrong. It should be a space.
> 
> Secondly, "master.kernel.org" doesn't support ssh'ing into it any
> more, and can't be used the way you claim I should use it.
> 
> IOW, that thing should have been
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git scsi-misc
> 
> so please fix your script to do that,

OK, fixed and resent.  Thanks,

James


