From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 13:39:24 -0800
Message-ID: <20050119213924.GG5508@us.ibm.com>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:64964 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S261916AbVASVkv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 16:40:51 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0JLefm4372984
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 16:40:41 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0JLeejI311754
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 14:40:40 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0JLedPx025431
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 14:40:40 -0700
Content-Disposition: inline
In-Reply-To: <20050119172106.GB32702@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Greg KH [greg@kroah.com] wrote:
> On Wed, Jan 19, 2005 at 06:13:57PM +0100, Christoph Hellwig wrote:
> > I think the hardware_version, firmware_version, rom_version and
> > driver_version don't belong into the FC transport class, there's
> > nothign specific to FC or even SCSI specific in them.
> 
> Then put them in the individual driver (not the driver_version one
> though, that belongs as a MODULE_VERSION() paramater).

Are there plans to export MODULE_VERSION info in /sys/module/*/ ? I
believe the intent was to try and use libsysfs to access these attributes
/ info.

-andmike
--
Michael Anderson
andmike@us.ibm.com

