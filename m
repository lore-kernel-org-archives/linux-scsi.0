From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/35] block: add REQ_OP definitions and bi_op/op fields
Date: Sat, 9 Jan 2016 05:37:16 -0800
Message-ID: <20160109133716.GB26660@infradead.org>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
 <1452027218-32303-3-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452027218-32303-3-git-send-email-mchristi@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: mchristi@redhat.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

Seems like this is missing REQ_OP_FLUSH, which still hides as a write?

