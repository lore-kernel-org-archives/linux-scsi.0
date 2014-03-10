From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 1/3] libata, libsas: kill pm_result and related cleanup
Date: Mon, 10 Mar 2014 16:29:47 -0400
Message-ID: <20140310202947.GG25290@htj.dyndns.org>
References: <20140305201443.20088.85361.stgit@viggo.jf.intel.com>
 <20140305201730.20088.42218.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140305201730.20088.42218.stgit@viggo.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@Parallels.com, Phillip Susi <psusi@ubuntu.com>, Todd Brandt <todd.e.brandt@intel.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Wed, Mar 05, 2014 at 12:17:30PM -0800, Dan Williams wrote:
> +#define ata_port_resume_sync(ap, msg) ata_port_resume_common((ap), (msg), false)
> +#define queue_ata_port_resume(ap, msg) ata_port_resume_common((ap), (msg), true)

Let's please use proper static functions.  The compiler can deal with
inlining.  Also, maybe ata_port_resume() and ata_port_resume_async()
are better names for the wrappers?

Other than that, libata part looks good to me.

Thanks.

-- 
tejun
