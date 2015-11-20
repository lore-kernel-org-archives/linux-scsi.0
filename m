From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Fri, 20 Nov 2015 11:16:44 +0100
Message-ID: <20151120101644.GC24298@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-3-git-send-email-hch@lst.de> <564B697A.2020601@sandisk.com> <564C2F01.6020407@dev.mellanox.co.il> <564CC15E.7030602@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564CC15E.7030602@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 18, 2015 at 10:20:14AM -0800, Bart Van Assche wrote:
> Are you perhaps referring to the sysfs CPU mask that allows to control 
> workqueue affinity ?

I think he is referring to the defintion of WQ_UNBOUND:

  WQ_UNBOUND

	Work items queued to an unbound wq are served by the special
	woker-pools which host workers which are not bound to any
	specific CPU.  This makes the wq behave as a simple execution
	context provider without concurrency management.  The unbound
	worker-pools try to start execution of work items as soon as
	possible.  Unbound wq sacrifices locality but is useful for
	the following cases.

	* Wide fluctuation in the concurrency level requirement is
	  expected and using bound wq may end up creating large number
	  of mostly unused workers across different CPUs as the issuer
	  hops through different CPUs.

	* Long running CPU intensive workloads which can be better
	  managed by the system scheduler.
