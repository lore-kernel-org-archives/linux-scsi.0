From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Mon, 09 Apr 2018 17:54:33 +0200
Message-ID: <20ba00cdfd1428aff13b7ea4cb42b03c@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5jL8oLV2xvjBVYv_SNXr74LdgpXEmU7K+cLYpD7jh2chgw@mail.gmail.com>
 <CAGXu5j+mVc6O_=GOF3YQmS4QZxeFgVPQtMxNH8sjBAhpJLjm9w@mail.gmail.com>
 <2679696.GDoj5zcZOu@natalenko.name> <20180409093520.GB10405@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180409093520.GB10405@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, paolo.valente@linaro.org
List-Id: linux-scsi@vger.kernel.org

Hi.

09.04.2018 11:35, Christoph Hellwig wrote:
> I really can't make sense of that report.

Sorry, I have nothing to add there so far, I just see the symptom of 
something going wrong in the ioctl code path that is invoked by 
smartctl, but I have no idea what's the minimal environment to reproduce 
it. I'll try to collect more info.

> And I'm also curious why
> you think 17cb960f29c2 should change anything for that code path.

Maybe, I've just mis-read that code.

Regards,
   Oleksandr
