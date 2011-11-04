From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
Date: Fri, 4 Nov 2011 07:38:11 -0700
Message-ID: <CAOS58YMM=75x_hCjRjV8a8j4eSLUuaRf1CEaPvZ=VXz0Qkj6qw@mail.gmail.com>
References: <4EB2BC88.3070105@suse.cz>
	<20111103161436.GJ4417@google.com>
	<20111103162634.GK4417@google.com>
	<20111104104042.46a33554@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111104104042.46a33554@stein>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jiri Slaby <jslaby@suse.cz>, "James E.J. Bottomley" <jejb@parisc-linux.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Fri, Nov 4, 2011 at 2:40 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
>> =A0 =A0 =A0 /* @q won't process any more request, flush async action=
s */
>> =A0 =A0 =A0 del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer=
);
>
> What prevents elevator_attach to be called and requests to be inserte=
d
> between 'if (q-elevator)' and 'blk_put_queue(q)'?

The fact that the queue owner has called blk_cleaup_queue()?

Thanks.

--=20
tejun
