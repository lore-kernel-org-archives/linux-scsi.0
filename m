From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Date: Sun, 16 Jan 2011 15:11:57 -0800
Message-ID: <AANLkTik=Pv1KdiBa3RbSoqmDC92F33jyFb0b-Ej_iGRN@mail.gmail.com>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
 <20110116141105.59e5b3a2@stein> <1295214807.22813.57.camel@haakon2.linux-iscsi.org>
 <20110117000659.57352da7@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110117000659.57352da7@stein>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 16, 2011 at 3:06 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> I for one think that layered "select" directives will open too many cans
> of worms.
>
> Best don't use select at all.

That really doesn't work.

The reason everybody wants "select", and "depends on" is near useless,
is that from a usability perspective, it's totally unacceptable to say
"you need to know to enable that random other totally conceptually
unrelated config option".

Why the hell should a OCFS2 user have to know that he needs to enable
configfs to be able to enable ocfs2?

The thing is, we should do exactly the reverse of what you say, and
work towards the goal of "depends on" going away. Right now, the main
reason to use "depends on" is actually just that our Kconfig solvers
are stupid, and don't generally handle "select" very well. But that's
hopefully getting fixed.

                   Linus
