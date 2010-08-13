From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/11] fs, block: propagate REQ_FLUSH/FUA interface to upper layers
Date: Fri, 13 Aug 2010 09:47:13 +0200
Message-ID: <20100813074713.GA24428@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-11-git-send-email-tj@kernel.org> <20100812212404.GB3665@quack.suse.cz> <4C64F21D.7010409@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C64F21D.7010409@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

FYI: I've already sent a patch to kill BH_Ordered, hopefully Al will
still push it in this merge window.

