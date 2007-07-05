From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch 0/3] clean gendisk out of scsi ULD structs
Date: Fri, 6 Jul 2007 00:03:37 +0100
Message-ID: <20070705230337.GT21478@ftp.linux.org.uk>
References: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com> <468D6C17.8030006@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35231 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761510AbXGEXDp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 19:03:45 -0400
Content-Disposition: inline
In-Reply-To: <468D6C17.8030006@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, James.Bottomley@SteelEye.com, akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 06:09:27PM -0400, Douglas Gilbert wrote:
> Since a scsi_device object is usually a SCSI logical unit,
> one wonders why it would contain a gendisk object. Logical
> units aren't necessarily disks, they might be enclosures or
> just place holders that respond to an INQUIRY (e.g. lun=0
> when the enclosing target has other active lus whose lun!=0).

gendisk is just a tag for requests coming into given queue.
