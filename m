From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [PATCH] allow NULL dev argument to scsi_add_host
Date: Mon, 13 Jan 2003 00:11:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030112231151.GA20678@win.tue.nl>
References: <20030111203317.A25836@lst.de> <20030112011720.GC1878@beaverton.ibm.com> <20030112090647.A28861@lst.de> <20030112194030.GB1414@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030112194030.GB1414@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Jan 12, 2003 at 11:40:30AM -0800, Mike Anderson wrote:

> Currently we have a couple of issues that might be solved by the creation of a
> scsi subsystem in /sysfs/scsi:

Is /sysfs/scsi better than /sysfs/devices/scsiX?

Andries
