From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI: export sas_hash_addr()
Date: Thu, 27 Sep 2007 20:04:05 -0400
Message-ID: <1190937846.5392.46.camel@localhost.localdomain>
References: <20070926073557.GA22773@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35844 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756413AbXI1AEI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 20:04:08 -0400
In-Reply-To: <20070926073557.GA22773@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 2007-09-26 at 03:35 -0400, Jeff Garzik wrote:
> sas_hash_addr() is the spec-defined standard hashing function.  Make it
> available to drivers that need it.

I'm not opposed in principle to exporting this, but I have a hard time
understanding why a driver would need it.

The hashed address is a property of the constructed SAS frames, which is
done in libsas.  The driver shouldn't really be calculating its own hash
instead of using what libsas provides ... or is this because the hashed
self address isn't calculated by the HBA so it needs to be programmed or
something?

James


