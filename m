From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] make scsi_wait_scan always modular
Date: Sun, 11 Mar 2007 16:06:17 -0500
Message-ID: <1173647177.3420.24.camel@mulgrave.il.steeleye.com>
References: <1173640604.3420.21.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.60.0703112141580.5942@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56581 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932367AbXCKVGZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Mar 2007 17:06:25 -0400
In-Reply-To: <Pine.LNX.4.60.0703112141580.5942@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2007-03-11 at 21:56 +0100, Guennadi Liakhovetski wrote:
> Which means, with this change you cannot build a kernel without module 
> support but with scsi_wait_scan, which was possible before. Don't know if 
> anybody would ever want to do this though...

I'll do something about that if you can tell me how one might use
scsi_wait_scan without module support in the kernel ...

James


