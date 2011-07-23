From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/2] block: strict rq_affinity
Date: Fri, 22 Jul 2011 21:46:33 -0400
Message-ID: <20110723014633.GA32507@infradead.org>
References: <20110722205736.17420.41366.stgit@localhost6.localdomain6>
 <20110722205938.17420.68621.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110722205938.17420.68621.stgit@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: jaxboe@fusionio.com, Christoph Hellwig <hch@infradead.org>, Roland Dreier <roland@purestorage.com>, Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 22, 2011 at 01:59:39PM -0700, Dan Williams wrote:
> Some storage controllers benefit from completions always being steered
> to the strict requester cpu rather than the looser "per-socket" steering
> that blk_cpu_to_group() attempts by default.

Isn't this actually dependent on the cpu, and not the storage
controller?
