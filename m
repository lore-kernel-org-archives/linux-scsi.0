From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Crash on WRITE SAME
Date: Wed, 2 Jul 2014 11:36:07 -0700
Message-ID: <20140702183607.GA19117@infradead.org>
References: <alpine.LRH.2.02.1407021338550.20183@file01.intranet.prod.int.rdu2.redhat.com>
 <20140702181333.GA15792@infradead.org>
 <alpine.LRH.2.02.1407021423240.20183@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1407021423240.20183@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 02, 2014 at 02:29:05PM -0400, Mikulas Patocka wrote:
> And what about protection information for commands that transfer partial 
> sectors? (for example, UMAP transfers 24 bytes). Should 
> scsi_transfer_length return 24 or 32 in this case?

As far as I understand so far PI is only defined for READ/WRITE
commands.  But I'll defer to Martin who is a much better source for
information on this topic.
