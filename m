From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
  take#2
Date: Thu, 16 Dec 2010 19:11:28 +0100
Message-ID: <4D0A5650.2010004@kernel.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <4D0A3EE1.4050404@kernel.org> <4D0A400F.5090608@kernel.dk> <AANLkTi=d78R=1=7Ngm-CVLS9xTU-U0BojVi9fS5z5hr8@mail.gmail.com> <4D0A4196.8040209@kernel.dk> <4D0A4231.2070402@kernel.org> <4D0A4594.6030704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D0A4594.6030704@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jack@suse.cz, James.Bottomley@hansenpartnership.com
List-Id: linux-scsi@vger.kernel.org

On 12/16/2010 06:00 PM, Jens Axboe wrote:
>> Heh, that was fast.  Anyways, James, it would be great if you can take
>> a look at the sr/sd changes.  I think they're correct but that's kinda
>> expected, so... :-)
> 
> One thing I noticed is that cdrom_check_events() needs an export.

Yeap, indeed.  Thanks for taking care of it.

-- 
tejun
