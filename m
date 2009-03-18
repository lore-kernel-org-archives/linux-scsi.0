From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 2/3] scsi_dh: Change scsi device handler
	modules	to	utilize modalias
Date: Wed, 18 Mar 2009 11:50:51 -0700
Message-ID: <1237402251.14147.5.camel@chandra-ubuntu>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013627.26548.27704.sendpatchset@chandra-ubuntu>
	 <20090318134629.GB19448@mars.virtualiron.com>
	 <49C1168F.6060900@s5r6.in-berlin.de>
	 <1237397158.14147.3.camel@chandra-ubuntu>
	 <49C1344D.30502@s5r6.in-berlin.de>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:39700 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZCRSr4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2009 14:47:56 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e37.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2IIlUwJ011398
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 12:47:30 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2IIlqb5187794
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 12:47:52 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2IIlp0A005234
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 12:47:52 -0600
In-Reply-To: <49C1344D.30502@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Konrad Rzeszutek <konrad@virtualiron.com>, linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

yes (all others are off).

 that is the only storage I have in my system 
On Wed, 2009-03-18 at 18:50 +0100, Stefan Richter wrote:
> Chandra Seetharaman wrote:
> > On Wed, 2009-03-18 at 16:43 +0100, Stefan Richter wrote:
> >> AFAICS you could have kept the check for .vendor != NULL instead of
> >> .vendor[0] != '\0' and write the terminator thusly:
> >>
> >> 	{},
> >>
> >> Saves the space for a one byte long string in the object files.  :-)
> > 
> > Tried it after your response. Got a panic :(.
> > 
> > Did I code your suggestion correctly ?
> > 
> > Here is the patch
> ...
> 
> Was scsi_dh_rdac the only device handler which you built?
> (All others configured off?)

