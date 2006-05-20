From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: dev_printk output
Date: Sat, 20 May 2006 08:46:57 -0500
Message-ID: <1148132817.3529.1.camel@mulgrave.il.steeleye.com>
References: <20060511150015.GJ12272@parisc-linux.org>
	 <20060512170854.GA11215@us.ibm.com>
	 <20060513050059.GR12272@parisc-linux.org>
	 <20060518183652.GM1604@parisc-linux.org>
	 <20060518200957.GA29200@us.ibm.com>
	 <20060519201142.GB2826@parisc-linux.org> <20060519202847.GB8865@kroah.com>
	 <20060520045544.GD2826@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:52631 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964854AbWETNrI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 May 2006 09:47:08 -0400
In-Reply-To: <20060520045544.GD2826@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2006-05-19 at 22:55 -0600, Matthew Wilcox wrote:
> Then we still get the inconsistency of device names changing as
> drivers
> are loaded.  I think we should declare it a bug for devices to not be
> on a bus.  The only example I have of devices not-on-a-bus are scsi
> targets.  I would propose introducing a new scsi_target bus for them,
> then removing the 'target' from the start of the bus_id.  Adding them
> to
> the scsi bus looks like it'd be a lot of work.

It's not just the target.  All the intermediate devices in transport
classes don't have busses either.   The only reason scsi_device has a
bus is so we can use the driver model to bind the ULDs.

James


