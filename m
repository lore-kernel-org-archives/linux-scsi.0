From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Next round of SCSI updates for 3.2 merge window
Date: Tue, 10 Jan 2012 10:36:59 -0800
Message-ID: <CA+55aFzR7Qvhoo9QVy-0RzPkqQ=J-DBpLurYSV7azMbQGOJchg@mail.gmail.com>
References: <1325801944.2775.32.camel@dabdike.Larkspurhotels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1325801944.2775.32.camel@dabdike.Larkspurhotels.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 5, 2012 at 2:19 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The patch is available here:
>
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git#scsi-misc

No it's not.

Please fix your crappy script.

First off, that '#' is wrong. It should be a space.

Secondly, "master.kernel.org" doesn't support ssh'ing into it any
more, and can't be used the way you claim I should use it.

IOW, that thing should have been

  git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git scsi-misc

so please fix your script to do that,

                   Linus
