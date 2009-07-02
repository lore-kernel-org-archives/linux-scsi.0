From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 0/3] scsi_dh: Add ability to set parameters for scsi
	device handler
Date: Thu, 02 Jul 2009 13:47:02 -0700
Message-ID: <1246567622.7381.7.camel@chandra-ubuntu>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
	 <1246563299.8018.9.camel@eddie-laptop>
	 <1246566564.8018.21.camel@eddie-laptop>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:37088 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZGBUoa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2009 16:44:30 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e38.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n62KfLUO004503
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jul 2009 14:41:21 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n62KiVcK105070
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jul 2009 14:44:31 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n62KiUdL007713
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jul 2009 14:44:31 -0600
In-Reply-To: <1246566564.8018.21.camel@eddie-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Williams <Eddie.Williams@steeleye.com>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com


On Thu, 2009-07-02 at 16:29 -0400, Eddie Williams wrote:
> On Thu, 2009-07-02 at 15:34 -0400, Eddie Williams wrote:
> > I have tried to set this up but have run into a problem probably due to
> > my error.  It has been a while since I have had to build kernels...
> > 
> > I pulled 2.6.31-rc1, applied the two patches below and then applied the
> > 3 patches for the interface.  The new kernel loads fine but when a
> > trespass command is sent I get an panic.  I am looking though how I
> > built the kernel and perhaps build with your 3 patches to see if it
> > happened before.  
> 
> I backed out the 3 patches with the same panic.
> 
Which version of the kernel were you originally testing with ? (when you
found the feature was gone).

