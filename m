From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [LSF/MM TOPIC] KPTI effect on IO performance
Date: Thu, 1 Feb 2018 10:35:21 +0800
Message-ID: <20180201023520.GA23923@ming.t460p>
References: <20180131082331.GA25888@ming.t460p>
 <d6729ac299e153de259cb8f8af0c888b@eng.utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d6729ac299e153de259cb8f8af0c888b@eng.utah.edu>
Sender: linux-block-owner@vger.kernel.org
To: Scotty Bauer <sbauer@eng.utah.edu>
Cc: lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Hi Scotty,

On Wed, Jan 31, 2018 at 11:43:33AM -0700, Scotty Bauer wrote:
> On 2018-01-31 01:23, Ming Lei wrote:
> > Hi All,
> > 
> > After KPTI is merged, there is extra load introduced to context switch
> > between user space and kernel space. It is observed on my laptop that
> > one
> > syscall takes extra ~0.15us[1] compared with 'nopti'.
> > 
> > IO performance is affected too, it is observed that IOPS drops by 32% in
> > my test[2] on null_blk compared with 'nopti':
> > 
> > randread IOPS on latest linus tree:
> > -------------------------------------------------
> > | randread IOPS     | randread IOPS with 'nopti'|
> > ------------------------------------------------
> > | 928K              | 1372K                     |
> > ------------------------------------------------
> > 
> > 
> 
> Do you know if your CPU has PCID? It would be interesting to see these tests
> on older CPUs or older kernels without PCID support.

My CPU has PCID, which can be retrieved via /proc/cpuinfo.

And the above test is run on same kernel binary, and the result is just done
between 'nopti' and no 'nopti' in kernel command line.

Thanks,
Ming
