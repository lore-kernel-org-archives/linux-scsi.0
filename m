From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH/RESEND v2 0/2] SATA disk resume time optimization
Date: Tue, 17 Dec 2013 07:15:27 -0500
Message-ID: <20131217121527.GB29989@htj.dyndns.org>
References: <20131017193331.GA11747@linux.intel.com>
 <527AF287.7020700@ubuntu.com>
 <20131109012023.GA8978@linux.intel.com>
 <527EA218.6010604@ubuntu.com>
 <20131111165920.GA25366@linux.intel.com>
 <52810F21.9070605@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52810F21.9070605@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: todd.e.brandt@linux.intel.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 11, 2013 at 12:08:49PM -0500, Phillip Susi wrote:
> No, I did not tune my system; I fixed the kernel so that userspace's
> activities do not start those disks.

So, umm, implementing things in kernel to facilitate userland is great
but please don't try to work around userland from kernel.  It may be
easy now but inevitably becomes a maintenance burden where we don't
have much visibility into what userland is depending on.  If a certain
feature needs cooperation from userland, update userland accordingly.

Thanks.

-- 
tejun
