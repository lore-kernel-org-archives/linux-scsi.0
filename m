From: Kees Cook <keescook@chromium.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Thu, 12 Apr 2018 15:47:49 -0700
Message-ID: <CAGXu5j+dh1zm32iBjRVh0s+3gLJYgjwt+z1aBJmrK2Cr8XPWnA@mail.gmail.com>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
 <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
 <2864697.7uzmEJovl2@natalenko.name> <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, paolo.valente@linaro.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 12, 2018 at 3:01 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Apr 12, 2018 at 12:04 PM, Oleksandr Natalenko
> <oleksandr@natalenko.name> wrote:
>> Hi.
>>
>> On =C4=8Dtvrtek 12. dubna 2018 20:44:37 CEST Kees Cook wrote:
>>> My first bisect attempt gave me commit 5448aca41cd5 ("null_blk: wire
>>> up timeouts"), which seems insane given that null_blk isn't even built
>>> in the .config. I managed to get the testing automated now for a "git
>>> bisect run ...", so I'm restarting again to hopefully get a better
>>> answer. Normally the Oops happens in the first minute of running. I've
>>> set the timeout to 10 minutes for a "good" run...

After fixing up some build issues in the middle of the 4.16 cycle, I
get an unhelpful bisect result of commit 0a4b6e2f80aa ("Merge branch
'for-4.16/block'". Instead of letting the test run longer, I'm going
to switch to doing several shorter test boots per kernel and see if
that helps. One more bisect coming...

>> Apparently, you do this on Linus' tree, right? If so, I won't compile it=
 here
>> then.
>
> Actually, I didn't test Linus's tree, but I can do that after the most
> recent bisect finishes... I'm just trying to find where it went wrong
> in 4.16.

FWIW, I see an Oops under Linus's latest tree.

-Kees

--=20
Kees Cook
Pixel Security
