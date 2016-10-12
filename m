From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 00/44] Convert FibreChannel bsg code to use bsg-lib
Date: Wed, 12 Oct 2016 09:06:17 +0200
Message-ID: <20161012070609.42s2z3fs3yz57m3s@linux-x5ow.site>
References: <cover.1476180827.git.jthumshirn@suse.de>
 <20161011164938.GA6083@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161011164938.GA6083@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 11, 2016 at 09:49:38AM -0700, Christoph Hellwig wrote:
> Hi Johannes,
> 
> this looks great to me.  But is there a chance to consolidate it into
> a more manageable set of patches?  E.g. all the patches to call
> export fc_bsg_jobdone, use it directly and remove the function pointer
> could go together, possibly even including the new calling convention.
> Similar all the patches about fc_bsg_to_shost could be merged into one,
> and if we add the bsg refcounting early, we could maybe skip a few
> steps of the conversion later on?

Sure, I think 44 patches is a bit huge. Especially given the 0day bot
fallout it generated. Let me see how I can slim it down.

	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
