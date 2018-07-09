From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI
Date: Mon, 9 Jul 2018 08:56:50 -0700
Message-ID: <CAGXu5jKvUydp6nc3EUCyoGWbUUoiiASMFcBfVVOph1uc_oCNSg@mail.gmail.com>
References: <CAGXu5j+mgGZkTDS6EDRspJKKbU=vMT4ehv9T-SekPba=ESoGDg@mail.gmail.com>
 <9A0BC289-4203-4C77-A012-AAB07F42061F@kernel.dk> <CAGXu5jJsGWDsZNDJvUUqncSaAcvond_B_J7=BbvVW0X3r6Sxww@mail.gmail.com>
 <aa150272-ffeb-fb8f-7303-0d9502cf9a71@kernel.dk> <20180523142545.GA16248@infradead.org>
 <24d36869-e037-042d-cb16-20a81b34eb76@kernel.dk> <CAGXu5jJn=1Rz=D8VUwv_VoaGoLtaD=+tcPZxQxntweZoZwFa5Q@mail.gmail.com>
 <f4eb4cd5-8976-3990-69b0-26cca054aa45@kernel.dk> <20180524080015.GA2866@infradead.org>
 <CAGXu5j+pRUWgny+h5ToVQXBP8nANjreVhnXjk5TVgy84ufNsRg@mail.gmail.com> <20180708202315.GA2239@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180708202315.GA2239@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

On Sun, Jul 8, 2018 at 1:23 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, May 24, 2018 at 10:06:59AM -0700, Kees Cook wrote:
>> On Thu, May 24, 2018 at 1:00 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Wed, May 23, 2018 at 03:14:19PM -0600, Jens Axboe wrote:
>> >> Ugh, so that would necessitate a change there too. As I said before,
>> >> I don't really care where it lives. I know the SCSI folks seem bothered
>> >> by moving it, but in reality, it's not like this stuff will likely ever
>> >> really change. Of the two choices (select entire SCSI stack, or just move
>> >> this little bit), I know what I would consider the saner option...
>> >
>> > Oh well.  How about something like this respin of Kees' series?
>> >
>> > http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/sense-cleanup
>>
>> Does the CONFIG_PCMCIA in drivers/scsi/Makefile now get exposed in
>> weird config cases?
>>
>> Otherwise, yeah, looks good to me. Thanks!
>
> Btw, did you plan to resend the series with this and your changes
> applied?

Yeah, I've gotten distracted. I'll try to get to it in the next few days.

Thanks for the reminder!

-Kees

-- 
Kees Cook
Pixel Security
