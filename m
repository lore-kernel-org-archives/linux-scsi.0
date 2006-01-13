From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] fusion: kzalloc / kcalloc conversion
Date: Fri, 13 Jan 2006 16:06:38 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7C7@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61875 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1423090AbWAMXG5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 18:06:57 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Friday, January 13, 2006 10:28 AM, Christoph Hellwig wrote: 

> 
> Convert kmalloc + memset to kzalloc or kcalloc in fusion.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>


ACK, please apply

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

