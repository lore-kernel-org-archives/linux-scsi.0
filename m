From: Branden Bonaby <brandonbonaby94@gmail.com>
Subject: Re: [PATCH] scsi: storvsc: Add ability to change scsi queue depth
Date: Tue, 18 Jun 2019 21:56:46 -0400
Message-ID: <20190619015646.GA21617@Test-Virtual-Machine>
References: <20190614234822.5193-1-brandonbonaby94@gmail.com>
 <yq1fto6xtxw.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1fto6xtxw.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org, jejb@linux.ibm.com, linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 18, 2019 at 09:08:59PM -0400, Martin K. Petersen wrote:
> 
> Branden,
> 
> > Adding functionality to allow the SCSI queue depth to be changed, by
> > utilizing the "scsi_change_queue_depth" function.
> 
> Applied to 5.3/scsi-queue. Please run checkpatch before submission. I
> fixed it up this time.
> 
> Thanks!

Oh I see what you mean about the brackets, thanks will do next time.
