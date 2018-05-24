From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI
Date: Thu, 24 May 2018 01:00:15 -0700
Message-ID: <20180524080015.GA2866@infradead.org>
References: <20180522191309.GA23615@infradead.org>
 <8d4af5c4-96fa-54ee-d5c1-b887b1de5a3c@kernel.dk>
 <CAGXu5j+mgGZkTDS6EDRspJKKbU=vMT4ehv9T-SekPba=ESoGDg@mail.gmail.com>
 <9A0BC289-4203-4C77-A012-AAB07F42061F@kernel.dk>
 <CAGXu5jJsGWDsZNDJvUUqncSaAcvond_B_J7=BbvVW0X3r6Sxww@mail.gmail.com>
 <aa150272-ffeb-fb8f-7303-0d9502cf9a71@kernel.dk>
 <20180523142545.GA16248@infradead.org>
 <24d36869-e037-042d-cb16-20a81b34eb76@kernel.dk>
 <CAGXu5jJn=1Rz=D8VUwv_VoaGoLtaD=+tcPZxQxntweZoZwFa5Q@mail.gmail.com>
 <f4eb4cd5-8976-3990-69b0-26cca054aa45@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f4eb4cd5-8976-3990-69b0-26cca054aa45@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 23, 2018 at 03:14:19PM -0600, Jens Axboe wrote:
> Ugh, so that would necessitate a change there too. As I said before,
> I don't really care where it lives. I know the SCSI folks seem bothered
> by moving it, but in reality, it's not like this stuff will likely ever
> really change. Of the two choices (select entire SCSI stack, or just move
> this little bit), I know what I would consider the saner option...

Oh well.  How about something like this respin of Kees' series?

http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/sense-cleanup
