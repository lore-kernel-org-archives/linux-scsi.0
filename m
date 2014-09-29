From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 33/38] libata: use __scsi_print_command()
Date: Mon, 29 Sep 2014 10:06:06 -0400
Message-ID: <20140929140606.GB15925@htj.dyndns.org>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
 <1411991947-130166-34-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411991947-130166-34-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 29, 2014 at 01:59:02PM +0200, Hannes Reinecke wrote:
> libata already uses an internal buffer, so we should be using
> __scsi_print_command() here.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-ide@vger.kernel.org
> Cc: LKML <linux-kernel@vger.kernel.org>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Applied to libata/for-3.18.

Thanks.

-- 
tejun
