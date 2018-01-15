From: Laurence Oberman <loberman@redhat.com>
Subject: Re: HP ProLiant DL360p Gen8 hangs with Linux 4.13+.
Date: Mon, 15 Jan 2018 11:25:18 -0500
Message-ID: <1516033518.3900.2.camel@redhat.com>
References: <CACKvgLEtPRpAS58kn-Skjn65-ZkDK17_cE+OzJodxQ=XvtQPGg@mail.gmail.com>
         <1515973240.8994.2.camel@redhat.com> <20180115121659.GA17687@ming.t460p>
         <1516020679.21554.1.camel@redhat.com>
         <20180115150135.GA14157@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180115150135.GA14157@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Hellwig, Christoph" <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>, Vinson Lee <vlee@freedesktop.org>, linux-scsi@vger.kernel.org, Don Brace <don.brace@microsemi.com>, Jens Axboe <axboe@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-01-15 at 07:01 -0800, Hellwig, Christoph wrote:
> Laurence, I'm a little confused.  Is this the same issue we just
> fixed,
> or is this an issue showing up with the fix?
> 
> E.g. what kernel versions or trees are affected?

Hello Christoph

This showed up on a  combined tree of Mikes and Jens (4.15.0-
rc4.block.dm.4.16) I was testing this weekend but was not apparent on
the generic upstream 4.15-rc7 from Linus.
I have to admit that was puzzling me.

When I removed your commit the issue went away.

Ming has crafted a fix so that your original commit can remain in and I
am testing that now against the same tree that was hanging before.

Ming has a handle on the issue so I will report back after testing.

Kernel is building now

Thanks
Laurence
