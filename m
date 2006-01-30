From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptsas: don't complain on bogus slave_alloc calls
Date: Mon, 30 Jan 2006 12:49:49 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F2211A1@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49404 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964826AbWA3TuI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 14:50:08 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Monday, January 30, 2006 11:01 AM, Christoph Hellwig wrote:

> 
> When people use the userspace scanning facilities on SAS hardware the
> LLDD gets bogus slave_alloc calls.  Just fail those gracefully instead
> of printing a warning in mptsas and another one in the midlayer.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

ACK, pls apply.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>
