From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 08/11] block: cleanup rq->data_len usages
Date: Mon, 04 May 2009 18:41:32 +0400
Message-ID: <49FEFE9C.9060102@ru.mvista.com>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241423927-11871-9-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:

> With recent unification of fields, it's now guaranteed that
> rq->data_len always equals blk_rq_bytes().  Convert all non-IDE direct
> users to accessors.  IDE will be converted in a separate patch.

> Boaz: spotted incorrect data_len/resid_len conversion in osd.

> [ Impact: convert direct rq->data_len usages to blk_rq_bytes() ]

> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
