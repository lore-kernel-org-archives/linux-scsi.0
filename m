From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: lsscsi-0.07 + scsi host information?
Date: Fri, 14 Feb 2003 08:49:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030214084926.B25020@beaverton.ibm.com>
References: <3E4C1FAE.2090904@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E4C1FAE.2090904@torque.net>; from dougg@torque.net on Fri, Feb 14, 2003 at 09:43:58AM +1100
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Feb 14, 2003 at 09:43:58AM +1100, Douglas Gilbert wrote:

> I would like lsscsi to list SCSI hosts (portals?) but there
> doesn't seem to be enough normalized sysfs information
> available to do that. Is the "/sys/class/scsi-host" sub-tree
> the place to be looking? Of the scsi hosts I have, only
> scsi_debug (thanks to work by Mike Anderson) puts an
> entry in that sub-tree. I would also like to have normalized
> information from the scsi_host structure available (similar
> to what Patrick Mansfield provided for scsi devices).

We could add scsi_host attributes under the same place as the
scsi_host->host_gendev. But with sysfs, you could not tell if they were
pci or scsi_host attributes.

We also need a place in sysfs for scsi core attributes - like
max_scsi_luns, scsi_logging_level, max_scsi_report_luns, and maybe others,
so they can be set and checked via /sysfs. But drivers under sysfs must
(AFAIK) be on a "bus" and bind to devices on that same bus. For scsi core,
we are more like a library, and do not have a specific type and set of
devices to bind to.

-- Patrick Mansfield
