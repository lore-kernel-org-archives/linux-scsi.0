From: Konrad Rzeszutek <ketuzsezr@darnok.org>
Subject: Re: [PATCH]ibft: Fix the display of a few fields in the NIC attribute  structure in sysfs
Date: Sun, 12 Apr 2009 09:06:59 -0400
Message-ID: <200904120907.08828.ketuzsezr@darnok.org>
References: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com> <1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
Reply-To: ketuzsezr@darnok.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:46510 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDLNIf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2009 09:08:35 -0400
In-Reply-To: <1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ashutosh Naik <ashutosh.naik@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, pjones@redhat.com, konradr@linux.vnet.ibm.com, "Vishnu V. Mandyam" <vishnu@chelsio.com>

> The second question is who picks this up?  The drivers/firmware
> directory doesn't seem to have a dedicated tree, so I can take this
> through the SCSI tree if required or Andrew can take it through -mm.

Which way works best for everybody? I was thinking SCSI, since the end result 
of this module is to configure the storage used to bootstrap the box.
