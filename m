From: Martijn Coenen <maco@android.com>
Subject: Re: [PATCH 2/6] module: add support for symbol namespaces.
Date: Tue, 24 Jul 2018 09:44:25 +0200
Message-ID: <CAB0TPYHu2tDuefRCfdUd_A8XqRQ_ym811ua-Cu3C=xUPnyHTGw@mail.gmail.com>
References: <20180716122125.175792-1-maco@android.com> <20180716122125.175792-3-maco@android.com>
 <20180719163208.5xvrafugpcbhh7kj@linux-8ccs> <CAB0TPYFVSWtJ6RPRUZ1bpS-rBaV7YyPR-4B2Ogxs+FNAbiScNw@mail.gmail.com>
 <20180720144916.fyqpmrtgt23sax6n@linux-8ccs> <CAB0TPYFQvkTsMvfJCTSFSJAoCbmOUJz7mCQGoORs6nRcC3Fhdg@mail.gmail.com>
 <20180723111251.x2cam6bcuglr4hhz@linux-8ccs>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180723111251.x2cam6bcuglr4hhz@linux-8ccs>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>, Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@codeaurora.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org, linux-m68k <linux-m68k@lists.linux-m68k.org>, USB list <linux-usb@vger.kernel.org>USB
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 23, 2018 at 1:12 PM, Jessica Yu <jeyu@kernel.org> wrote:
> IMO I don't think we should bend over backwards to accommodate
> out-of-tree modules - modifying the module loader to recognize even
> more special sections to accommodate these OOT modules would be where
> we'd draw the line I think.

I agree with you, I really don't like making the module loader more
complex (which is why I didn't opt to create separate sections in the
first place), and in the end this change will in some ways benefit
out-of-tree drivers too, even though it will be a bit painful now.

> I think going forward I would prefer to have export namespaces to be a
> normal and regular part of kernel API (as in, we shouldn't require a
> new option for it), and that the warnings for 1-2 cycles are courteous
> enough - but anyone with stronger opinions about this should speak up.

That aligns with how I think about this; if we want this to be a
standard thing in the kernel, we should at some point enforce it,
because it's pretty easy to ignore the warning. The good thing is that
it's not a big on/off switch, but subsystem maintainers can just
introduce namespaces when it makes sense.

Thanks,
Martijn

>
> Thanks,
>
> Jessica
