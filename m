From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Tue, 2 Oct 2018 07:56:13 -0700
Message-ID: <20181002145613.GA11156@infradead.org>
References: <20180930205448.26205-1-natechancellor@gmail.com>
 <10b12992-3570-4646-374b-82cbd7276839@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10b12992-3570-4646-374b-82cbd7276839@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 01, 2018 at 06:16:32PM -0700, Bart Van Assche wrote:
> Boaz, the most recent osd patch that is neither trivial nor treewide
> refactoring is six years old (51976a8c85ce ("[SCSI] osd_uld: Add osdname &
> systemid sysfs at scsi_osd class"). That suggests that nobody is using this
> driver anymore. Can this driver be removed from the kernel tree?

Last time we tried to exofs and the osd code Boaz complained loudly,
but as far as I can tell it really is not used and bitrotting, so we
should finally go ahead and drop it.
