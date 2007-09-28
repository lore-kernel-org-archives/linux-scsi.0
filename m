From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] SCSI: export sas_hash_addr()
Date: Thu, 27 Sep 2007 21:01:40 -0400
Message-ID: <46FC5274.10802@garzik.org>
References: <20070926073557.GA22773@havoc.gtf.org> <1190937846.5392.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58043 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630AbXI1BBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2007 21:01:42 -0400
In-Reply-To: <1190937846.5392.46.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2007-09-26 at 03:35 -0400, Jeff Garzik wrote:
>> sas_hash_addr() is the spec-defined standard hashing function.  Make it
>> available to drivers that need it.
> 
> I'm not opposed in principle to exporting this, but I have a hard time
> understanding why a driver would need it.
> 
> The hashed address is a property of the constructed SAS frames, which is
> done in libsas.  The driver shouldn't really be calculating its own hash
> instead of using what libsas provides ... or is this because the hashed
> self address isn't calculated by the HBA so it needs to be programmed or
> something?

It is needed to build the SSP frame header.

If there is common code that does that, I will definitely use that, but 
do not see any such code.

	Jeff



