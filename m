From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: [PATCH 0/3] scsi_dh: Add ability to set parameters for scsi
 device handler
Date: Tue, 07 Jul 2009 08:34:42 -0400
Message-ID: <1246970082.6646.9.camel@eddie-laptop>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
	 <1246563299.8018.9.camel@eddie-laptop>
	 <1246566564.8018.21.camel@eddie-laptop>
	 <1246567622.7381.7.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o145.mxlogic.net ([208.65.145.78]:45704 "EHLO
	p02c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbZGGMeo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2009 08:34:44 -0400
In-Reply-To: <1246567622.7381.7.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com


I was testing with the SLES 11 kernel.  Initially I was using
2.6.27.19-5 and also verified the same issue with their errata kernel
2.6.27.23-0.1.

Eddie
On Thu, 2009-07-02 at 13:47 -0700, Chandra Seetharaman wrote:
> On Thu, 2009-07-02 at 16:29 -0400, Eddie Williams wrote:
> > On Thu, 2009-07-02 at 15:34 -0400, Eddie Williams wrote:
> > > I have tried to set this up but have run into a problem probably due to
> > > my error.  It has been a while since I have had to build kernels...
> > > 
> > > I pulled 2.6.31-rc1, applied the two patches below and then applied the
> > > 3 patches for the interface.  The new kernel loads fine but when a
> > > trespass command is sent I get an panic.  I am looking though how I
> > > built the kernel and perhaps build with your 3 patches to see if it
> > > happened before.  
> > 
> > I backed out the 3 patches with the same panic.
> > 
> Which version of the kernel were you originally testing with ? (when you
> found the feature was gone).
> 

