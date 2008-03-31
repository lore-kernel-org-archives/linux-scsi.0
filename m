From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [patch 02/17] Dell CERC support for megaraid_mbox
Date: Mon, 31 Mar 2008 08:33:05 -0600
Message-ID: <9738BCBE884FDB42801FAD8A7769C26502084DD9@NAMAIL1.ad.lsil.com>
References: <1206897220.4224.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46808 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYCaOds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 10:33:48 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1206897220.4224.50.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, hare@suse.de, "Patro, Sumant" <Sumant.Patro@lsi.com>


James,

I am checking with our FW team for the random deletion logic drive
(RDLD) for Dell CERC firmware (>= 6.62) implementation.  We should have
the RDLD support if the driver found the FW support the RDLD.

Thanks.

Bo Yang

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Sunday, March 30, 2008 1:14 PM
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org; hare@suse.de; Yang, Bo; Patro, Sumant
Subject: Re: [patch 02/17] Dell CERC support for megaraid_mbox

On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Newer Dell CERC firmware (>= 6.62) implement a random deletion 
> handling compatible with the legacy megaraid driver.  The legacy 
> handling shifted the target ID by 0x80 only for I/O commands 
> (READ/WRITE/etc), whereas megaraid_mbox shifts the target ID always if
random deletion is supported.
> The resulted in megaraid_mbox sending an INQUIRY to the wrong channel,

> and not finding any devices, obviously.
> 
> So we disable the random deletion support if the offending firmware is

> found.
> 
> Addresses http://bugzilla.kernel.org/show_bug.cgi?id=6695

Bo,

You said you'd review this patch and give feedback "soon" twenty five
days ago (5 March).  My patience finally ran out on this one; you have
three days (that's until midnight CST on 2 April) to provide an ack or a
replacement patch for this otherwise I'll apply it anyway.

James


