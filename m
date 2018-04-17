From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 17 Apr 2018 11:02:08 +0100
Message-ID: <1523959328.3250.11.camel@linux.vnet.ibm.com>
References: <10360653.ov98egbaqx@natalenko.name>
         <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
         <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
         <2864697.7uzmEJovl2@natalenko.name>
         <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
         <CAGXu5j+dh1zm32iBjRVh0s+3gLJYgjwt+z1aBJmrK2Cr8XPWnA@mail.gmail.com>
         <CAGXu5jLhnWnUiscP9B=kTEFNyRw9jgFn7Zr5FxhZrO20553+1Q@mail.gmail.com>
         <CAGXu5jKuZwicyyXH2gB3vp-OjtS+MkG+hqxV1cq1jaG9vAAO=g@mail.gmail.com>
         <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bart.vanassche@wdc.com>, Paolo Valente <paolo.valente@linaro.org>
Cc: David Windsor <dave@nullcore.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-04-16 at 20:12 -0700, Kees Cook wrote:
> I still haven't figured this out, though... any have a moment to look
> at this?

Just to let you know you're not alone ... but I can't make any sense of
this either.  The bfdq is the elevator_data, which is initialised when
the scheduler is attached, so it shouldn't change.  Is it possible to
set a data break point on elevator_data after it's initialised and see
if it got changed by something?

James
