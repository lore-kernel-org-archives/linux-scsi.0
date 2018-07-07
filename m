From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Fri, 6 Jul 2018 19:48:52 -0700
Message-ID: <CA+55aFxAy__3hE1OoUFPKZfptLT1cXuoujsnSGXBMzJPQ+Qjzg@mail.gmail.com>
References: <1530913134.3135.2.camel@HansenPartnership.com>
 <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com> <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 6, 2018 at 7:39 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'd rather add a deprecation warning to the whole "read/write
> to /dev/sg" itself

In the meantime, I've pulled this, but do wonder why we actually allow
that crazy read/write that doesn't even work for any other models (ie
I guarantee you that cdrom writers etc don't use that interface,
because SG_IO is the only thing that works on most hardware).

              Linus
