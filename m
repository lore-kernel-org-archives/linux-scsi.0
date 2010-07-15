From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch 1/1] block: Apply segment size and boundary limits to
 integrity data
Date: Thu, 15 Jul 2010 09:53:24 -0600
Message-ID: <4C3F2EF4.6020203@kernel.dk>
References: <20100715153410.774329000@de.ibm.com> <20100715154547.485829000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100715154547.485829000@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/15/2010 09:34 AM, Christof Schmitt wrote:
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> 
> Apply the conditions used in __blk_recalc_rq_segments also to
> integrity data: Adhere to the maximum segment size and the segment
> boundary set by the driver. Without this change, a driver would
> receive integrity data blocks that do not adhere to the limits set for
> the request queue.

Thanks. The level of duplication there is nasty, particularly for such
intricate code as this that has had bugs in the past in the core.

-- 
Jens Axboe
