From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 5/5] target: Fix wrong setting of sense format for PI
 errors
Date: Wed, 8 Jul 2015 03:19:31 -0700
Message-ID: <20150708101931.GD14466@infradead.org>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-6-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436188508-1539-6-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 06, 2015 at 04:15:08PM +0300, Sagi Grimberg wrote:
> PI errors should be reported in a descriptor format sense data.
> Fix that by adding a desc_format flag to struct sense_info and pass
> it to scsi_build_sense_buffer() to do the right thing.

Do we really need the additional flag?  We only need the descriptor
sense format because we add the sector information.  So just checking
for that should be enough, especially when paired with a comment
explaining that logic in the source file.
