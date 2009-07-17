From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules
	automatically inserted
Date: Thu, 16 Jul 2009 18:01:16 -0700
Message-ID: <1247792476.670.20.camel@chandra-ubuntu>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
	 <4A369320.2080202@redhat.com> <1245365306.4286.27.camel@mulgrave.site>
	 <4A3BDFE8.3090003@redhat.com> <4A44D37A.10903@redhat.com>
	 <1246986723.6277.63.camel@mulgrave.site> <4A538B13.8050809@redhat.com>
	 <1246990464.6277.74.camel@mulgrave.site>
	 <1246995401.9541.15.camel@chandra-ubuntu>
	 <20090708155808.GA31204@infradead.org>  <4A54E65D.8050706@redhat.com>
	 <1247690016.9792.5.camel@chandra-ubuntu>
	 <1247706999.8632.8.camel@mulgrave.site>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:60574 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbZGQBAc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2009 21:00:32 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e37.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n6H0vONp012943
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2009 18:57:24 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6H0wCJ9221098
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2009 18:58:12 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6H0wAq8014595
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2009 18:58:11 -0600
In-Reply-To: <1247706999.8632.8.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hare@suse.de, Peter Jones <pjones@redhat.com>


On Thu, 2009-07-16 at 01:16 +0000, James Bottomley wrote:
> On Wed, 2009-07-15 at 13:33 -0700, Chandra Seetharaman wrote:
> > James,
> > 
> > Please let us know which way you want us to proceed ?
> 
> Yes, propose a mechanism that keeps manual binding but allows the dm-mp
> user an exception. 

James, this is the current behavior. We wanted to make the binding
automatic, hence the patches.

>  For the actual binding I still think it should be
> part of generic driver multiple binding.

I don't quite understand what does this mean. Can you elaborate, please.

> 
> > We have been pursuing this for more than three months now.
> 
> Well, the concerns I flagged at the outset haven't really changed ...
> they just seem finally to be better understood.
> 
> James
> 
> 

