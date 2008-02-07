From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCHSET #upstream] block/libata: update and use block layer
 padding and draining
Date: Wed, 06 Feb 2008 19:09:55 -0500
Message-ID: <47AA4C53.5050503@garzik.org>
References: <12021979851743-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <12021979851743-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, Jens.Axboe@oracle.com, James.Bottomley@HansenPartnership.com, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> This patchset updates block layer padding and draining support and
> make libata use it.  It's based on James Bottomley's initial work and,
> of the five, the last two patches are from James with some
> modifications.
> 
> Please read the following thread for more info.
> 
>   http://thread.gmane.org/gmane.linux.scsi/37185
> 
> This patchset is on top of
> 
>   upstream (a6af42fc9a12165136d82206ad52f18c5955ce87)
> + kill-n_iter-and-fix-fsl patch [1]

ACK patchset...  lets definitely get these fixes upstream.

Once Jens is happy, I would prefer the merge the lot upstream, if that 
is OK with everyone involved?

	Jeff



