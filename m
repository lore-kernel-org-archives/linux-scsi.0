From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Crash on WRITE SAME
Date: Wed, 2 Jul 2014 11:13:33 -0700
Message-ID: <20140702181333.GA15792@infradead.org>
References: <alpine.LRH.2.02.1407021338550.20183@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1407021338550.20183@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 02, 2014 at 02:05:14PM -0400, Mikulas Patocka wrote:
> Hi Sagi
> 
> Your commit d77e65350f2d82dfa0557707d505711f5a43c8fd causes crash on SCSI 
> WRITE SAME command (it can be triggered by issuing the BLKZEROOUT ioctl). 
> The crash happens in iscsi_tcp_segment_done because sg_next returns NULL.

Martin already fixes this over a week ago, we're just waiting for James
to send a pull request to Linus.

Get this fix from the core-for-3.16 branch of
git.infradead.org/users/hch/scsi-queue.git for now.
