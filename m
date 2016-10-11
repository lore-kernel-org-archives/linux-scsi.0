From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/44] Convert FibreChannel bsg code to use bsg-lib
Date: Tue, 11 Oct 2016 09:49:38 -0700
Message-ID: <20161011164938.GA6083@infradead.org>
References: <cover.1476180827.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Johannes,

this looks great to me.  But is there a chance to consolidate it into
a more manageable set of patches?  E.g. all the patches to call
export fc_bsg_jobdone, use it directly and remove the function pointer
could go together, possibly even including the new calling convention.
Similar all the patches about fc_bsg_to_shost could be merged into one,
and if we add the bsg refcounting early, we could maybe skip a few
steps of the conversion later on?
