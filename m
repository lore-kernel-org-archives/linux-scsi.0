From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LDM scsi upper level updates and scsihosts parm
Date: Sat, 31 May 2003 10:32:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030531103255.A28131@infradead.org>
References: <20030531010844.GA25468@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:6921 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264252AbTEaJTf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 May 2003 05:19:35 -0400
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 19M2jP-0007Jm-00
	for linux-scsi@vger.kernel.org; Sat, 31 May 2003 10:32:55 +0100
Content-Disposition: inline
In-Reply-To: <20030531010844.GA25468@beaverton.ibm.com>; from andmike@us.ibm.com on Fri, May 30, 2003 at 06:08:45PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, May 30, 2003 at 06:08:45PM -0700, Mike Anderson wrote:
> The sysfs changes to allow the upper level to bind through the driver
> model interfaces breaks the usage of the scsihosts parm. I did not
> notice this the other day as I was running with one built-in driver and
> many modules.
> 
> I know there are issues with using scsihosts today (i.e., does not
> work if you come in after the upper levels have inited).
> 
> Are we going to remove the scsihosts parm or do we need a solution for
> this?

I think we should remove it.  It's racy and we have proper ways to identify
filesysystems bz label/uuid or scsi hosts by the sysfs output nowdays.

Btw, did someone update the scsidev util to use 2.5 sysfs output?

