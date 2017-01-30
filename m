From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: scsi: use-after-free in sg_start_req
Date: Mon, 30 Jan 2017 17:48:56 +0100
Message-ID: <CACT4Y+a3HSJ0vMR3jOyhBFZ0MwcQpTZCHgsoj5PYBZPtGYJ+QQ@mail.gmail.com>
References: <CACT4Y+bwWs4cndXQfCXyaM8Z-YOvxvj0+8rW4GhzfwESDAtGaA@mail.gmail.com>
 <1485794148.2712.2.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485794148.2712.2.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 30, 2017 at 5:36 PM, Bart Van Assche
<Bart.VanAssche@sandisk.com> wrote:
> On Mon, 2017-01-30 at 08:25 +0100, Dmitry Vyukov wrote:
>> On commit ca63ff9b11f958efafd8c8fa60fda14baec6149c
>
> What kernel have you been testing? That commit is not in any upstream kernel.

This is mmotm
git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git
auto-latest ca63ff9b11f958efafd8c8fa60fda14baec6149c

commit ca63ff9b11f958efafd8c8fa60fda14baec6149c
Date:   Wed Jan 25 18:36:03 2017 +0800
    mm/migration: make isolate_movable_page always defined
