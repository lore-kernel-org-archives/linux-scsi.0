From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] sas: fix removal of devices behind expanders
Date: Wed, 4 Jan 2006 11:24:37 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F153772@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:30968 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965256AbWADSYw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2006 13:24:52 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Wednesday, January 04, 2006 5:45 AM, Christoph Hellwig wrote:

> We need to iterate over all children when removing and expander, else
> stale objects will be around after host removal.  This fixes the oops
> Eric Moore saw when removing and reloading mptsas.
> 
> Also don't try the scsi_remove_target call unless operating on an end
> device.  The current unconditional call is harmless but confusing.
> 
> 

Thanks, that solves my oops.  Please apply.


Eric Moore
