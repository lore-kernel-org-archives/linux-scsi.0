From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/3] libsas: add support for port multiplier
Date: Fri, 2 May 2014 11:36:17 -0400
Message-ID: <20140502153617.GH10204@htj.dyndns.org>
References: <1398346023-10225-1-git-send-email-yxlraid@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1398346023-10225-1-git-send-email-yxlraid@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Xiangliang Yu <yxlraid@gmail.com>
Cc: JBottomley@parallels.com, dan.j.williams@intel.com, todd.e.brandt@intel.com, lukasz.dorau@intel.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 24, 2014 at 09:27:03PM +0800, Xiangliang Yu wrote:
> This patch set will support SATA port multiplier(PM) in LIBSAS. 
> 
> LIBSAS is need to implement several key handling to support SATA PM:
> First,low level driver notify libsas that SATA PM is attached to HBA port.
> Then, LIBSAS will need to schedule SATA PMP error handler to scan SATA device
> that is attached to PM, so we must implemet port softreset and PMP reset 
> handling.
> If find SATA devices, we should add the devices into SAS transport layer.
> In order to find SAS domain device we must implemet device type transformation
> : scsi device -> (port number) -> ata device -> domain device. Then, we can
> execute IO operation.
> 
> In these patches, patch 1 is change SATA error handler.
> And patch 2 will add SATA device into SAS layer and implement device type
> transformation. Patch 3 implement SATA functional interface in mvsas.

Please properly thread the patchset from the next posting.

Dan, can you please take a look at this?

Thanks.

-- 
tejun
