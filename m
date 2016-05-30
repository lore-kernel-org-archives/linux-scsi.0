From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Mon, 30 May 2016 12:10:52 -0700
Message-ID: <20160530191052.GB366@infradead.org>
References: <1464407471-3712-1-git-send-email-fangwei1@huawei.com>
 <20160529065452.GA21677@infradead.org>
 <574BEF2F.9070707@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <574BEF2F.9070707@huawei.com>
Sender: linux-ide-owner@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>, tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, May 30, 2016 at 03:43:43PM +0800, Wei Fang wrote:
> I looked around the file, and didn't find the part should be updated.
> Would you point me out?

Lines 255 and 266 in Documentation/scsi/scsi_eh.txt
