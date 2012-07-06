From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] [SCSI] scsi_pm: set device runtime state before parent
 suspended
Date: Fri, 6 Jul 2012 10:24:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1207061023350.28821-100000@netrider.rowland.org>
References: <1341547617.6401.1.camel@chief-river-32>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341547617.6401.1.camel@chief-river-32>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 6 Jul 2012, Lin Ming wrote:

> There is a race in scsi_bus_resume_common when set device's runtime
> state to active after pm_runtime_put_sync(dev->parent).
> 
> Parent device may have been suspended so pm_runtime_set_active(dev) will
> fail with -EBUSY.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>
