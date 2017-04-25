From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] lpfc: Fix memory corruption of the lpfc_ncmd->list
 pointers
Date: Tue, 25 Apr 2017 11:00:39 -0700
Message-ID: <20170425180039.GE3575@infradead.org>
References: <20170422004908.24261-1-jsmart2021@gmail.com>
 <20170425175844.GC3575@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170425175844.GC3575@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: jsmart2021@gmail.com
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, sagi@grimberg.me, linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>, emilne@redhat.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, jthumshirn@suse.de
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 25, 2017 at 10:58:44AM -0700, Christoph Hellwig wrote:
> On Fri, Apr 21, 2017 at 05:49:08PM -0700, jsmart2021@gmail.com wrote:
> > This is a nvme-specific bug. The patch was cut against the
> > linux-block tree, for-4.12/block tree. It should be pulled in through
> > that tree.
> 
> It conflicts with your nvme changes that are in the nvme-4.12.
> Can you respin it?

Sorry for the noise.  It applies fine and I've applied it.
