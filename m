From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Subject: Re: rtsadmin-v1.99 BETA packages
Date: Fri, 13 May 2011 18:41:51 -0700
Message-ID: <1305337311.7102.88.camel@haakon2.linux-iscsi.org>
References: <1304121705.14278.196.camel@haakon2.linux-iscsi.org>
	 <1304553788.10072.241.camel@haakon2.linux-iscsi.org>
	 <4DCAC075.5090007@redhat.com>
	 <1305160226.19744.47.camel@haakon2.linux-iscsi.org>
Reply-To: nab@risingtidesystems.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58838 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1ENBuA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2011 21:50:00 -0400
In-Reply-To: <1305160226.19744.47.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jerome Martin <jxm@risingtidesystems.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>, Stefan Hajnoczi <stefanha@gmail.com>, linux-iscsi-target-dev <linux-iscsi-target-dev@googlegroups.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Paolo Bonzini <pbonzini@redhat.com>

On Wed, 2011-05-11 at 17:30 -0700, Nicholas A. Bellinger wrote:
> On Wed, 2011-05-11 at 09:59 -0700, Andy Grover wrote:
> > [CCing lists too.]
> > 
> > Hi Nicholas,
> > 
> > Thank you to you, Jerome and RTS for this work!
> > 
> > The rtsadmin-frozen rpm from 04-May-2011 installed ok but didn't seem to
> > work quite right, but I wouldn't worry about it. I'm working on rpm
> > packages with proper dependencies for Fedora rawhide, hopefully they'll
> > be ready within a few days and I can make binary+src rpms available.
> > 
> 
> Hey Andy,
> 
> Thanks alot for this status update wrt to rtsadmin-v2 userspace.  I am
> really looking forward to seeing rtsadmin-v2 community edition available
> very soon in Fedora rawhide.  We (RTS) are also very excited to expose
> the v2 shell to a larger audience using mainline >= .38 target v4
> infrastructure.
> 
> We believe that having an interactive target shell and python library
> available to developers and users is criticaly important to the success
> of the mainline target ecosystem as a whole.  We are very proud to be
> able to work with the upstream community to achieve this important
> milestone with the v2 shell.
> 
> Thank you Andy!!
> 
> --nab
> 

Hello everyone,

Just a quick update on the userspace side..

This afternoon's updated RHEL6 and Debian Squeeze BETA builds are
available here:

http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/rtsadmin-frozen-11.99-20110513091048.3434628.x86_64.rpm
http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/rtsadmin-frozen_11.99-20110513161709.3434628_amd64.deb

These contain an important bugfix for v2 device creation where 
/sys/kernel/config/target/core/$HBA/$DEV/wwn/vpd_unit_serial
was not being automatically generated for newly created virtual devices.
There is also a seperate multi-fabric export HBA context 'delete
$DEVICE_NAME' that has been fixed as well and pushed into the community
repo.

Also, the lio-utils v4.0 packages for RHEL6 and Debian Squeeze have been
updated with a few minor improvements to tcm_fabric.py code.

http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/lio-utils-4.0-d2cf595d.x86_64.rpm
http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/lio-utils_4.0_amd64.deb

Please let us know if you have any questions.

Thanks!

--nab

