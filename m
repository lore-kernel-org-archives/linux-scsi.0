From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] scsi: sd: don't crash the host on invalid commands
Date: Fri, 21 Sep 2018 06:52:35 -0700
Message-ID: <e082c821-e019-7e41-12b8-5295a207d3fb@acm.org>
References: <20180921070101.9260-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921070101.9260-1-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 9/21/18 12:01 AM, Johannes Thumshirn wrote:
> When sd_init_command() get's a with a unknown req_op() it crashes the
> system via BUG().
> 
> This makes debugging the actual reason for the broken request
> cmd_flags pretty hard as the system is down before it's able to write
> out debugging data on the serial console or the trace buffer.
> 
> Change the BUG() to a WARN_ON() and return BLKPREP_KILL to fail
> gracefully and return an I/O error to the producer of the request.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
