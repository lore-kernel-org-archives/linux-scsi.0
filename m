From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 09:22:08 -0600
Message-ID: <1257348128.2697.29.camel@mulgrave.site>
References: <4AF17AD3.6060909@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbZKDPWJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2009 10:22:09 -0500
In-Reply-To: <4AF17AD3.6060909@Calva.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Hughes <john@Calva.COM>
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-11-04 at 14:00 +0100, John Hughes wrote:
> No sign of an enclosure.
> 
> I've tried with a Debian  2.6.26-2-xen-amd64 kernel, and a 2.6.31 I 
> build myself.
> 
> Any clues about what I should to to diagnose this problem?

Tell me what disks you have first.  Currently the matching algorithm
only works with SAS disks because we have no VPD translation for SATA.
Hopefully I'll be getting a SATA device to put in an enclosure at some
point, so I can play with this (at the moment I only have one SATA
device and I'm using it for data storage ...).

James


