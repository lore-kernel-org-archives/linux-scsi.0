From: Christoph Hellwig <hch@infradead.org>
Subject: Re: slave_destroy called in scsi_scan.c:scsi_probe_and_add_lun()
Date: Tue, 17 Dec 2002 22:33:41 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021217223341.A26529@infradead.org>
References: <170040000.1040080786@aslan.btc.adaptec.com> <20021217054102.GH13989@redhat.com> <797140000.1040156703@aslan.btc.adaptec.com> <20021217222459.GD28100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021217222459.GD28100@redhat.com>; from dledford@redhat.com on Tue, Dec 17, 2002 at 05:24:59PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

On Tue, Dec 17, 2002 at 05:24:59PM -0500, Doug Ledford wrote:
> Well, that or I need Jens to clean up the block layer allocation code so 
> that it only allocates one request at block queue init time and from then 
> on does lazy request allocations once the device needs them, similar to 
> what I did with the scsi command blocks.

What do you think about forward-porting akpm's blk_grow_request_list()
changes in 2.4?  I could do that easily and it should help to get this 
sorted out properly.

