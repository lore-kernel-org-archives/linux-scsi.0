From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/2] RFC: iscsi ibft: separate ibft parsing from sysfs
 interface
Date: Wed, 11 Aug 2010 09:04:45 -0700
Message-ID: <20100811090445.8462591f.randy.dunlap@oracle.com>
References: <1271095578-4212-1-git-send-email-michaelc@cs.wisc.edu>
	<201004122220.30193.konrad@darnok.org>
	<20100811085435.7da9dcff.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:23276 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab0HKQGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2010 12:06:05 -0400
In-Reply-To: <20100811085435.7da9dcff.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, pjones@redhat.com, open-iscsi@googlegroups.com

On Wed, 11 Aug 2010 08:54:35 -0700 Randy Dunlap wrote:

> On Mon, 12 Apr 2010 22:20:29 -0400 Konrad Rzeszutek Wilk wrote:
> 
> > On Monday 12 April 2010 14:06:17 michaelc@cs.wisc.edu wrote:
> > > From: Mike Christie <michaelc@cs.wisc.edu>
> > >
> > > Not all iscsi drivers support ibft. For drivers like be2iscsi
> > > that do not but are bootable through a vendor firmware specific
> > > format/process this patch moves the sysfs interface from the ibft code
> > > to a lib module. This then allows userspace tools to search for iscsi boot
> > > info in a common place and in a common format.
> > >
> > > ibft iscsi boot info is exported in the same place as it was
> > > before: /sys/firmware/ibft.
> > >
> > > vendor/fw boot info gets export in /sys/firmware/iscsi_bootX, where X is
> > > the scsi host number of the HBA. Underneath these parent dirs, the
> > > target, ethernet, and initiator dirs are the same as they were before.
> > >
> > > This patch was made over the ibft-2.6 tree's ibft-1.03 branch:
> > > http://git.kernel.org/?p=linux/kernel/git/konrad/ibft-2.6.git;a=shortlog;h=
> > >refs/heads/ibft-1.03
> > >
> > >
> > > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> > > ---
> > Looks good to my eyes.
> > 
> > Let me run it tomorrow through my regression bucket before I stick on the git 
> > tree.
> 
> Can we get this patch into linux-next, please?
> 
> or if it's there, there are still errors like this that need to be checked.

Sorry, I replied to the (a) wrong email (thread).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
