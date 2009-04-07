From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Tue, 07 Apr 2009 20:59:33 +0000
Message-ID: <1239137973.29492.12.camel@mulgrave>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
	 <ac3eb2510903181130s5dd1b1caje579d765fd338f6f@mail.gmail.com>
	 <1237403902.14147.25.camel@chandra-ubuntu>
	 <1237488880.26341.15.camel@chandra-ubuntu>  <49C3DF49.8050408@redhat.com>
	 <1237846429.14853.6.camel@chandra-ubuntu>
	 <1238798590.20924.0.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44351 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756038AbZDGU7d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 16:59:33 -0400
In-Reply-To: <1238798590.20924.0.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Peter Jones <pjones@redhat.com>

On Fri, 2009-04-03 at 15:43 -0700, Chandra Seetharaman wrote:
> Hi James,
> 
> Do you still have any concerns (after Peter's response) ?

Yes, the basic concerns still remain:

     1. You're forcing autoload now even if the user isn't running
        dm ... this is going to cause problems with non-dm based path
        handlers
     2. autoloading in this fashion is essentially trying to work around
        a problem in the initrd tools.  The kernel isn't the right place
        to implement the fix.

The risks of this approach seem very high, and the rewards pretty small.

James


