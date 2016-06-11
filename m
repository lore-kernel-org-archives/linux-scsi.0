From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.7-rc2
Date: Sat, 11 Jun 2016 12:12:46 -0700
Message-ID: <CA+55aFzoFPQB6GQ-bZZJQ2bQNxDyqioxZmsDxW=P7tVOauC+AA@mail.gmail.com>
References: <1465668572.2364.26.camel@HansenPartnership.com> <CA+55aFyBOPjFoVMzGhxarXBtRfCVBBarxt-+L-_T63Taam9_qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyBOPjFoVMzGhxarXBtRfCVBBarxt-+L-_T63Taam9_qA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, "Ewan D. Milne" <emilne@redhat.com>, Jan Stancek <jstancek@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 11, 2016 at 11:54 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Is there some reason to believe that the qemu CD-ROM emulation is the
> only one with this problem?

Side note:the one thing that makes the qemu cd-rom emulator "special"
is not that it's not real hardware: it's that it's a lot more likely
to be tested than just about any other actual cd-rom out there,
especially in environments that test new kernels. Lots of developers
tend to have rather modern machines (and I haven't had a CD-ROM in my
machine for the last couple of years, I think), or alternatively they
end up booting things in emulation because it makes for easy testing.

So I really don't think that "oh, it happened only with a broken
emulated device" is a very strong argument for saying that that
emulated device was the problem.

I really think it's likely that the whole "require VPD" is garbage.
The whole "everybody and their dog has used qemu, and the qemu cd-rom
emulation worked perfectly fine before" is a damn strong argument that
it's the new kernel doing something wrong.

So please figure our what the real breakage was, and fix *that*
instead of blaming qemu.

                Linus
