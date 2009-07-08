From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules
	automatically inserted
Date: Wed, 08 Jul 2009 11:21:00 -0700
Message-ID: <1247077260.1200.9.camel@chandra-ubuntu>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
	 <4A369320.2080202@redhat.com> <1245365306.4286.27.camel@mulgrave.site>
	 <4A3BDFE8.3090003@redhat.com> <4A44D37A.10903@redhat.com>
	 <1246986723.6277.63.camel@mulgrave.site> <4A538B13.8050809@redhat.com>
	 <1246990464.6277.74.camel@mulgrave.site>
	 <1246995401.9541.15.camel@chandra-ubuntu>
	 <20090708155808.GA31204@infradead.org>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:55997 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbZGHSSl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 14:18:41 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n68IGSGP014576
	for <linux-scsi@vger.kernel.org>; Wed, 8 Jul 2009 12:16:28 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n68IIFJo040868
	for <linux-scsi@vger.kernel.org>; Wed, 8 Jul 2009 12:18:16 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n68IIEKd010043
	for <linux-scsi@vger.kernel.org>; Wed, 8 Jul 2009 12:18:15 -0600
In-Reply-To: <20090708155808.GA31204@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Jones <pjones@redhat.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hare@suse.de


On Wed, 2009-07-08 at 11:58 -0400, Christoph Hellwig wrote:
> On Tue, Jul 07, 2009 at 12:36:41PM -0700, Chandra Seetharaman wrote:
> > I do not know of all the out-of-tree multipath solutions and how they
> > behave and at what layer they interact. In effect, I haven't tested
> > hardware handler with other multipath solutions.
> 
> It doesn't matter anyway.  We've never cared about these out of tree
> problems and they'll have to find a way by themselves to deal with any
> changes we do to offer better multipath support upstream.

Agree.

One simple way the out-of-tree multipath solutions can circumvent this
feature is by blacklisting the hardware handler modules in their
modprobe.conf file.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

