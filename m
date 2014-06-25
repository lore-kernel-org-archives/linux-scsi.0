From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [regression] fix 32-bit breakage in block device read(2) (was Re:
 32-bit bug in iovec iterator changes)
Date: Wed, 25 Jun 2014 09:56:09 -0700
Message-ID: <CA+55aFyEHiq4UVg=JHH5y=B8UefH8Y3QnrFcnmXy5uLnCDiZbQ@mail.gmail.com>
References: <20140621035144.GA8526@thunk.org>
	<20140621055306.GP18016@ZenIV.linux.org.uk>
	<20140621230922.GA13188@thunk.org>
	<20140621234913.GQ18016@ZenIV.linux.org.uk>
	<1403395400.2592.4.camel@jarvis.lan>
	<20140622002618.GR18016@ZenIV.linux.org.uk>
	<1403397164.2177.40.camel@dabdike.int.hansenpartnership.com>
	<20140622005352.GS18016@ZenIV.linux.org.uk>
	<20140622010032.GT18016@ZenIV.linux.org.uk>
	<20140622115007.GA5333@thunk.org>
	<20140623074440.GV18016@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140623074440.GV18016@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Al,
 just checking - did you expect me to take this from the email, or are
you preparing a pull request?

               Linus

On Mon, Jun 23, 2014 at 12:44 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK, here it is, hopefully with sufficient comments:
