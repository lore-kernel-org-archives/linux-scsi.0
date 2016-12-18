From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] qla2xxx: Remove se_cmd struct out of
 qla_tgt_cmd/qla_tgt_mgmt_cmd
Date: Sun, 18 Dec 2016 01:53:47 -0800
Message-ID: <20161218095347.GG23338@infradead.org>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
 <1482051769-22941-10-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482051769-22941-10-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 18, 2016 at 01:02:49AM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Move se_cmd struct outside of qla_tgt_cmd/qla_tgt_mgmt_cmd.
> To convert the pointer from one struct to another, new inline
> functions was added to take care of the convertion.
> 
> Cleanup dead SRR code.

Please send the dead code remoal as a separate patch just after
the bugfix series.
