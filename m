From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] libata: Support for an ATA PASS-THROUGH(32) command.
Date: Tue, 27 Jun 2017 11:27:26 -0400
Message-ID: <20170627152726.GC2289@htj.duckdns.org>
References: <1498243270-21730-1-git-send-email-dn3108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1498243270-21730-1-git-send-email-dn3108@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Minwoo Im <dn3108@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 24, 2017 at 03:41:10AM +0900, Minwoo Im wrote:
> SAT-4(SCSI/ATA Translation) supports for an ata pass-thru(32).
> This patch will allow to translate an ata pass-thru(32) SCSI cmd
> to an ATA cmd.
> 
> Signed-off-by: Minwoo Im <dn3108@gmail.com>
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>

Applied to libata/for-4.13.

Thanks.

-- 
tejun
