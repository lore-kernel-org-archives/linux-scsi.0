From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 0/6] Avoid that scsi-mq and dm-mq queue processing
 stalls sporadically
Date: Wed, 12 Apr 2017 12:55:38 +0200
Message-ID: <20170412105538.GB22576@bblock-ThinkPad-W530>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 07, 2017 at 11:16:48AM -0700, Bart Van Assche wrote:
> Hello Jens,
> 
> The six patches in this patch series fix the queue lockup I reported
> recently on the linux-block mailing list. Please consider these patches
> for inclusion in the upstream kernel.
> 

Hey Bart,

just out of curiosity. Is this maybe related to similar stuff happening
when CPUs are hot plugged - at least in that the stack gets stuck? Like
in this thread here:
https://www.mail-archive.com/linux-block@vger.kernel.org/msg06057.html

Would be interesting, because we recently saw similar stuff happening.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
