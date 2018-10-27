From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: remove exofs and the T10 OSD code V2
Date: Sat, 27 Oct 2018 13:32:51 -0700
Message-ID: <CAKwvOdnK5BfpkSos6HsaQ1V7Jmo-voA0=a6NqEAUNKS3WyLwUQ@mail.gmail.com>
References: <20181027082019.20838-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181027082019.20838-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: ooo@electrozaur.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nathan Chancellor <natechancellor@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 27, 2018 at 1:20 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The only real user of the T10 OSD protocol, the pNFS object layout
> driver never went to the point of having shipping products, and we
> removed it 1.5 years ago.  Exofs is just a simple example without
> real life users.
>
> The code has been mostly unmaintained for years and is getting in the
> way of block / SCSI changes, so I think it's finally time to drop it.
>
> Quote from Boaz:
>
> "As I said then. It is used in Universities for studies and experiments.
> Every once in a while. I get an email with questions and reports.
>
> But yes feel free to remove the all thing!!
>
> I guess I can put it up on github. In a public tree.
>
> Just that I will need to forward port it myself, til now you guys
> been doing this for me ;-)"

Hi Christoph,
Thanks for the series.  I suggest you pick up Nathan's patch:
https://github.com/ClangBuiltLinux/linux/commit/a37fa82bde58960c5c966a5c1bef8ace6c9d4f34
that removed the configs that were removed in this series from the
various defconfigs.

I think the other thread still has some questions about when it's ok
to remove filesystems. But it's ultimately the maintainers decision.
Let's continue the discussion in the other thread.
-- 
Thanks,
~Nick Desaulniers
