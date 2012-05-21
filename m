From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Mon, 21 May 2012 23:14:24 +0800
Message-ID: <CAF1ivSajZb_D9nOuA5gYeDgHgbvyqbCueV8+kDyy3DSBs1AumQ@mail.gmail.com>
References: <CAF1ivSYmY3d8VonvsX0orsj0fLKXOXsLoG5jSwLs90MoP7=5Dw@mail.gmail.com>
	<Pine.LNX.4.44L0.1205211059510.1725-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1205211059510.1725-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, May 21, 2012 at 11:00 PM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Mon, 21 May 2012, Lin Ming wrote:
>
>> On Fri, May 18, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.e=
du> wrote:
>> [snip]
>> > I may have left some parts out from this brief description. =A0Hop=
efully
>> > you'll be able to figure out the general idea and get it to work.
>>
>> All journal threads and flusher thread of the disk need to be freeze=
d
>> before suspend and thaw after resume.
>
> Why? =A0If any of those threads needs to write something to the disk
> while the disk is suspended, the disk will simply be resumed.

When tested the patches, I found that kjournald and flusher thread
frequently resume the disk.

I'm not familiar with journal.
Are the journal threads still need to be in active state when the disk
is already suspended?

>
> Alan Stern
