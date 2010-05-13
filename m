From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: burning small isos repeatedly failing with hangcheck error
Date: Wed, 12 May 2010 20:19:15 -0600
Message-ID: <AANLkTikt4nSwXxgsma4Nv2dLhHGhgQwNiH13aGgVYcZW@mail.gmail.com>
References: <201004261855.29335.tfjellstrom@strangesoft.net>
	 <201005101852.43114.tfjellstrom@strangesoft.net>
	 <4BEB5132.6060201@gmail.com>
	 <201005121919.24115.tfjellstrom@strangesoft.net>
	 <AANLkTinMOHdOGbghsZ9thgkXdFW0mQJRwJBu8EJbOB8k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AANLkTinMOHdOGbghsZ9thgkXdFW0mQJRwJBu8EJbOB8k@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 12, 2010 at 8:14 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On Wed, May 12, 2010 at 7:19 PM, Thomas Fjellstrom
> <tfjellstrom@strangesoft.net> wrote:
>>> > I do not recall having these issues with older kernels.
>>>
>>> Same wodim version? The commands (and ordering thereof) it is issuing
>>> could have an effect on this..
>>
>> I can't be certain that its the same version of wodim. I have often noticed
>> that it takes far longer to burn a small iso onto a DVDR than you'd
>> intuitively think it would, but I've never had this timeout error happen
>> prior to 2.6.33, not that that means the problem started with 2.6.33, I
>> can't recall how long its been since I last had to burn a really small iso
>> to a DVDR.
>>
>> I can try and test various versions of the kernel and wodim, if you think it
>> would help.
>
> I think different wodim versions (or try different software like
> growisofs, etc) would be the most promising option. There's really not
> a lot of influence the kernel has on this process, the burning
> software accesses the device with SG_IO which pretty much just passes
> ATAPI commands through to the drive.
>
> I thought I saw a report recently that some version of wodim was
> sending uninitialized values as the timeout for SG_IO commands, but I
> can't seem to find that mail at the moment..

Found the thread I was thinking of. It was growisofs that was
apparently doing that, though, not wodim:

http://lkml.org/lkml/2010/4/27/410
