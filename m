From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Thu, 12 Apr 2018 21:04:35 +0200
Message-ID: <2864697.7uzmEJovl2@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com> <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, paolo.valente@linaro.org
List-Id: linux-scsi@vger.kernel.org

Hi.

On =C4=8Dtvrtek 12. dubna 2018 20:44:37 CEST Kees Cook wrote:
> My first bisect attempt gave me commit 5448aca41cd5 ("null_blk: wire
> up timeouts"), which seems insane given that null_blk isn't even built
> in the .config. I managed to get the testing automated now for a "git
> bisect run ...", so I'm restarting again to hopefully get a better
> answer. Normally the Oops happens in the first minute of running. I've
> set the timeout to 10 minutes for a "good" run...

Apparently, you do this on Linus' tree, right? If so, I won't compile it he=
re=20
then.

Thanks for taking care of this.

Regards,
  Oleksandr
