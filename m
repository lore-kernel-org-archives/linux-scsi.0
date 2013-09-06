From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] scsi: sr: use block layer runtime PM
Date: Fri, 6 Sep 2013 10:26:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309061026160.1165-100000@iolanthe.rowland.org>
References: <52293763.5070206@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <52293763.5070206@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: James Bottomley <JBottomley@parallels.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 6 Sep 2013, Aaron Lu wrote:

> Migrate SCSI Optical Disk Drive(ODD) driver sr to make use of block
> layer runtime PM. Accordingly, the SCSI bus layer runtime PM callback is
> simplified as all SCSI devices that implement runtime PM are now request
> based.
> 
> Note that due to ODD will be polled every 2 seconds, for suspend to
> actually happen, the autosuspend_delay can not be set to more than 2
> seconds or the polling interval has to be increased.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

