From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Subject: Re: rtsadmin-v1.99 BETA packages
Date: Wed, 11 May 2011 18:56:38 -0700
Message-ID: <1305165398.19744.110.camel@haakon2.linux-iscsi.org>
References: <1304121705.14278.196.camel@haakon2.linux-iscsi.org>
	 <1304553788.10072.241.camel@haakon2.linux-iscsi.org>
	 <4DCAC075.5090007@redhat.com>
	 <1305160226.19744.47.camel@haakon2.linux-iscsi.org>
	 <4DCB3730.6060105@redhat.com>
Reply-To: nab@risingtidesystems.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60989 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1ELCEo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2011 22:04:44 -0400
In-Reply-To: <4DCB3730.6060105@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: linux-iscsi-target-dev@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <openosd@gmail.com>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jerome Martin <jxm@risingtidesystems.com>, Marc Fleischmann <mwf@risingtidesystems.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>, Stefan Hajnoczi <stefanha@gmail.com>, linux-scsi@vger.kernel.org

On Wed, 2011-05-11 at 18:26 -0700, Andy Grover wrote:
> On 05/11/2011 05:30 PM, Nicholas A. Bellinger wrote:
> > Thanks alot for this status update wrt to rtsadmin-v2 userspace.  I am
> > really looking forward to seeing rtsadmin-v2 community edition available
> > very soon in Fedora rawhide.  We (RTS) are also very excited to expose
> > the v2 shell to a larger audience using mainline >= .38 target v4
> > infrastructure.
> 
> Hi nab,
> 
> I've packaged rtsadmin + deps for f14 and f15, instead of rawhide.
> Fedora 14/15 users can add this repo:
> 
> http://repos.fedorapeople.org/repos/grover/rtsadmin/fedora-rtsadmin.repo
> 
> These are currently lacking docs but are functional.
> 
> Do I need to package lio-utils, or will it (imho preferably) be merged
> into rtsadmin before 2.0?
> 

Now that we do have a functional set for save/unload/restore ops with
lio-utils, this bit is considered medium priority in the short term as
the there are more important bits to enable for shell usability..

> Also, RPM really likes to start with a tarball from upstream -- I made
> these myself from git for this snapshot, but real, upstream tarballs are
> of course preferable, and leads me to ask: when should we expect the
> official 2.0 release?
> 

I expect by the time that .40 ships this fall we will have a stable v2.0
release with fully integrated save/restore logic from rtslib without any
legacy lio-utils dependencies.

> > We believe that having an interactive target shell and python
> > library available to developers and users is criticaly important to
> > the success of the mainline target ecosystem as a whole. We are very
> > proud to be able to work with the upstream community to achieve this
> > important milestone with the v2 shell.
> 
> Of course, for rtsadmin packages *you* are the upstream. :)
> 

:)

--nab


