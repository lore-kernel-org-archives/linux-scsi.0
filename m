From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Thu, 19 Jun 2008 12:10:08 -0600
Message-ID: <20080619181007.GL4392@parisc-linux.org>
References: <20080619160342.GJ4392@parisc-linux.org> <20080619171258.GA819@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54213 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYFSSKY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2008 14:10:24 -0400
Content-Disposition: inline
In-Reply-To: <20080619171258.GA819@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 19, 2008 at 10:12:58AM -0700, Mike Anderson wrote:
> Why would we want to do this in the kernel instead of a udev rule
> similar to how we set timeouts. Since there already exists a sysfs
> interface to change the IO scheduler it would seem this would be more
> flexible in case someone did not like the kernel policy selected.

You don't lose any flexibility either way; you can always change the
elevator default.  I just thought this would be a nice little hack to
give people with SSDs a better default.  I'm not against doing it with
udev, but it's not a lot of extra code either way.

> You would need some tool to obtain the vpd data from user space that would
> always be installed.

Yes.  I've been using sg_inq from sg3_utils to play with it, but one
could write a specialised tool very quickly.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
