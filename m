From: John Robinson <john.robinson@anonymous.org.uk>
Subject: OT grammar nit Re: [PATCH] block: simplify queue_next_fseq
Date: Mon, 23 Aug 2010 17:28:19 +0100
Message-ID: <4C72A1A3.3080806@anonymous.org.uk>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100823141512.GA23771@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100823141512.GA23771@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On 23/08/2010 15:15, Christoph Hellwig wrote:
> We need to call blk_rq_init and elv_insert for all cases in queue_next_fseq,
> so take these calls into common code.  Also move the end_io initialization
> from queue_flush into queue_next_fseq and rename queue_flush to
> init_flush_request now that it's old name doesn't apply anymore.

Nit: it's "its" above, not "it's". If in doubt, if it's "it is" (or "it 
has") it's "it's" but if it could be "his" or "hers" it's "its".

I'm guessing English isn't your first language (a) because of your .de 
address and (b) because it's better than most British people's, but 
still, it's a common mistake. If I can remember any of the German I 
studied all those years ago, "its" is roughly equivalent to "sein", and 
"it's" to "es ist".

Cheers,

John.
