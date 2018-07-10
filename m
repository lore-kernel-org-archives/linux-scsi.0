From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Tue, 10 Jul 2018 11:04:33 -0700
Message-ID: <CA+55aFwtSEJpOqOsU6+g9dDHyHGZjoABz-ga6mVx=GiredGnDw@mail.gmail.com>
References: <1530913134.3135.2.camel@HansenPartnership.com>
 <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com>
 <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
 <CA+55aFxAy__3hE1OoUFPKZfptLT1cXuoujsnSGXBMzJPQ+Qjzg@mail.gmail.com>
 <1530940958.3135.4.camel@HansenPartnership.com> <CA+55aFwg-2GP4ASTdd1pusmZkF7c8AN9febVDCaioDxzYJSLfw@mail.gmail.com>
 <CAG48ez0Ccpp3yv+FVX9Sp3WHqPh6US=quDjELmv5RYVgqfBtVg@mail.gmail.com> <CA+55aFx9iTm2rZqL1jo_mhAp7EQ8tHhU6MFCSG7XdqAxY_vUGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx9iTm2rZqL1jo_mhAp7EQ8tHhU6MFCSG7XdqAxY_vUGw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 10, 2018 at 10:49 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> > Also, the device is called /dev/sg%d with %d being sdp->index.
>
> I guess I could make it at least say that, although it's not like "one
> of them would be ok, but /dev/sd3 is right out".

Actually, I don't want to after all, because I don't even have 'spd'
available until later when we might have already returned ENXIO. I'd
rather have the warning right at the top of the function.

               Linus
