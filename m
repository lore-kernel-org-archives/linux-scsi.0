From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 17 Apr 2018 23:55:48 +0200
Message-ID: <182097a2acc78285019d95d7e750be9e@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
 <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
 <2864697.7uzmEJovl2@natalenko.name>
 <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
 <CAGXu5j+dh1zm32iBjRVh0s+3gLJYgjwt+z1aBJmrK2Cr8XPWnA@mail.gmail.com>
 <CAGXu5jLhnWnUiscP9B=kTEFNyRw9jgFn7Zr5FxhZrO20553+1Q@mail.gmail.com>
 <CAGXu5jKuZwicyyXH2gB3vp-OjtS+MkG+hqxV1cq1jaG9vAAO=g@mail.gmail.com>
 <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
 <CAGXu5jJTMqbXia7TmN2yEW11SM+XC3pkMt=bb+xBrY7-OOf=tw@mail.gmail.com>
 <CAGXu5j+xX3kDDS_sPY44hPVb=8isMX-evYzPx3ur=rge1rL5JQ@mail.gmail.com>
 <CAGXu5jJmvKcANUSsCz3fjGSv-tv1hceNd3rOpT4WTfYRb65RRA@mail.gmail.com>
 <8473f909-2123-0cfc-43b1-beba0b1aef9b@kernel.dk>
 <CAGXu5jL9miO3OXpjAxm9t8v=f_f5StB=Tk=aV8BVRdEj-Y-PDA@mail.gmail.com>
 <CAGXu5jKVPQi0cdTbe5Y1DNHdiJ6-kEFRBTNv7znuqT9w5eifGg@mail.gmail.com>
 <07f263ff-cea6-ac3c-944b-0f36fee8ba25@kernel.dk>
 <CAGXu5j+kHipvoyFWjGp8M6+83zbd6yHOzwxQ-2LNBQbD5-jS9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+kHipvoyFWjGp8M6+83zbd6yHOzwxQ-2LNBQbD5-jS9w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <bart.vanassche@wdc.com>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, keescook@google.com
List-Id: linux-scsi@vger.kernel.org

Hi.

17.04.2018 23:47, Kees Cook wrote:
> I sent the patch anyway, since it's kind of a robustness improvement,
> I'd hope. If you fix BFQ also, please add:
> 
> Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Root-caused-by: Kees Cook <keescook@chromium.org>
> 
> :) I gotta task-switch to other things!
> 
> Thanks for the pointers, and thank you Oleksandr for providing the 
> reproducer!

That was a great fun to read. Thank you for digging into it.

Regards,
   Oleksandr
