From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Patch:  allow devices to restrict start on add
Date: Thu, 22 May 2003 11:05:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030522110522.A7240@beaverton.ibm.com>
References: <200305221140.59633.Eddie.Williams@Steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:31682 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262976AbTEVR4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2003 13:56:12 -0400
Content-Disposition: inline
In-Reply-To: <200305221140.59633.Eddie.Williams@Steeleye.com>; from Eddie.Williams@steeleye.com on Thu, May 22, 2003 at 11:40:59AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Eddie Williams <Eddie.Williams@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Eddie -

On Thu, May 22, 2003 at 11:40:59AM -0400, Eddie Williams wrote:
> When a SCSI disk is added and it returns a NOT READY the SD driver is 
> automatically sending a START_UNIT command to spin the device up.  While this 
> may be the desired behavior for many if not most devices not all devices 
> either want or need this.  The attached patch provides a mechanism via the 

Can you elaborate on "want or need this"? Do they get errors?

Is this a clusters issue?

Also you should patch against scsi-misc-2.5, or a recent bk, since hch
moved all of the devinfo code into scsi_devinfo.c

-- Patrick Mansfield
