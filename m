From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [RFC PATCH 1/2] block: strict rq_affinity
Date: Sat, 23 Jul 2011 20:38:20 +0200
Message-ID: <4E2B151C.6080900@fusionio.com>
References: <20110722205736.17420.41366.stgit@localhost6.localdomain6> <20110722205938.17420.68621.stgit@localhost6.localdomain6> <20110723014633.GA32507@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110723014633.GA32507@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Roland Dreier <roland@purestorage.com>, Dave Jiang <dave.jiang@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2011-07-23 03:46, Christoph Hellwig wrote:
> On Fri, Jul 22, 2011 at 01:59:39PM -0700, Dan Williams wrote:
>> Some storage controllers benefit from completions always being steered
>> to the strict requester cpu rather than the looser "per-socket" steering
>> that blk_cpu_to_group() attempts by default.
> 
> Isn't this actually dependent on the cpu, and not the storage
> controller?

It is, it's completely indendent of the controller used. Perhaps some
drivers could have a very heavy end io completion handling causing the
problem to become larger, but in general it's an artifact of the CPU and
not the controller.

-- 
Jens Axboe
