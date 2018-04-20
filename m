From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Fri, 20 Apr 2018 22:41:33 +0200
Message-ID: <bd69860bb48eedc4908e055ff869c5a5@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
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
 <8b32e079-d4e6-3fea-a89d-ff856e4e13b1@kernel.dk>
 <0fbf2b13-8bae-c7c5-d930-ebaafdc72202@kernel.dk>
 <011EF7D1-B095-4B8D-AD2A-993048932C49@linaro.org>
 <c30400f9-50e6-b5cf-d06b-a5e971e98546@kernel.dk>
 <13DBFC76-4849-4DDA-AC44-B2C1257912E7@linaro.org>
 <CAGXu5j+8WUgr1y=JYhCkUqUWE0SJ+ymkM9DPEQwY8UoqPmoPSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+8WUgr1y=JYhCkUqUWE0SJ+ymkM9DPEQwY8UoqPmoPSw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bart.vanassche@wdc.com>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block <linux-block@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, keescook@google.com
List-Id: linux-scsi@vger.kernel.org

Hi.

On 20.04.2018 22:23, Kees Cook wrote:
> I don't know the "how", I only found the "what". :) If you want, grab
> the reproducer VM linked to earlier in this thread; it'll hit the
> problem within about 30 seconds of running the reproducer.

Just to avoid a possible confusion I should note that I've removed the 
reproducer from my server, but I can re-upload it if needed.

-- 
   Oleksandr Natalenko (post-factum)
