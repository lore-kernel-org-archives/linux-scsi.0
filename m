From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH 12/30] blk_end_request: changing ub (take 4)
Date: Fri, 14 Dec 2007 11:49:38 -0800
Message-ID: <20071214114938.b87883af.zaitcev@redhat.com>
References: <20071211154803.58beb681.zaitcev@redhat.com>
	<20071212.153815.39152138.k-ueda@ct.jp.nec.com>
	<20071213135916.27ebe3f9.zaitcev@redhat.com>
	<20071214.120454.39153297.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071214.120454.39153297.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, zaitcev@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 14 Dec 2007 12:04:54 -0500 (EST), Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> I have investigated all code paths which call ub_end_rq() in ub.c,
> and confirmed that ub_end_rq() is always called with the queue lock
> held.  (sc->lock is registered as a queue lock.)

Thanks for reminding me about blk_init_queue, I forgot. Sorry for the
confusion.

Greetings,
-- Pete
