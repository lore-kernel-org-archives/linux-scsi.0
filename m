From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [GIT PULL] isci: sas controller driver for 3.0
Date: Mon, 04 Jul 2011 16:07:04 +0200
Message-ID: <4E11C908.8020706@interlog.com>
References: <1309563349.19567.26.camel@dwillia2-linux> <20110704134529.GA8917@lst.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53821 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab1GDOHl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2011 10:07:41 -0400
In-Reply-To: <20110704134529.GA8917@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, James Bottomley <JBottomley@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, David Milburn <dmilburn@redhat.com>, Jeff Garzik <jeff@garzik.org>, Jacek Danecki <jacek.danecki@intel.com>, hare@suse.de

On 11-07-04 03:45 PM, Christoph Hellwig wrote:
> On Fri, Jul 01, 2011 at 04:35:48PM -0700, Dan Williams wrote:
>> James, please pull from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master
>>
>> ...to receive the isci driver that supports the integrated 6Gb/s SAS
>> capabilities of the upcoming Intel(R) C600 series chipset family.  This
>> part is targeted at standard servers / workstations and provides
>> up to 8-ports (2x4-port controllers) of SAS beyond the traditional SATA
>> ports (surfaced by the ahci driver).

s/surfaced/serviced/

> The driver looks okay to me.  It's not stellar, but so much better
> than the original.  I'll make sure to keep your TODO list long after
> the merge, though :)

