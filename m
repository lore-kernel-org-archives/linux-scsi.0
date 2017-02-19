From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: scsi: BUG in scsi_init_io
Date: Sun, 19 Feb 2017 09:56:00 -0800
Message-ID: <CA+55aFzKwKJ-K1Y39=m4BfGtScFPwriY6_4xA234Y5SYjs_7mQ@mail.gmail.com>
References: <CACT4Y+YAX_SmwzsHenzkswM0kp=om5NivmLW8d9Js6EN3zKmGQ@mail.gmail.com>
 <20170131092048.GB3687@linux-x5ow.site> <CACT4Y+Y0Yi43kN+sAOd=pu4FTnW4wPeGwiDHEU45s6DTXs_JmQ@mail.gmail.com>
 <1485877311.3199.4.camel@linux.vnet.ibm.com> <20170219071522.GI29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170219071522.GI29622@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Dmitry Vyukov <dvyukov@google.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 18, 2017 at 11:15 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> AFAICS, the minimal fix would be something like this:

Applied, along with getting rid of the BUG_ON() that made this bug
much worse than it would have been without it.

                    Linus
