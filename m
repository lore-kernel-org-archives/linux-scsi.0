From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Date: Wed, 18 Aug 2010 11:46:20 +0200
Message-ID: <20100818094620.GA14707@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1281616891-5691-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

FYI: One issue with this series is that make_request based drivers
not have to access all REQ_FLUSH and REQ_FUA requests.  We'll either
need to add handling to empty REQ_FLUSH requests to all of them or
figure out a way to prevent them getting sent.  That is assuming they'll
simply ignore REQ_FLUSH/REQ_FUA on normal writes.

