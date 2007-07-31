From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Tue, 31 Jul 2007 09:34:32 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D708B410A@NAMAIL4.ad.lsil.com>
References: <20070731083606E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:65109 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbXGaPfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 11:35:33 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070731083606E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

On Monday, July 30, 2007 5:36 PM, FUJITA Tomonori wrote:
> 
> Looks good for me.
> 
> Here's an updated version. Can you add your signed-off or acked-by?
> 
> ---
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] mptsas: add SAS management protocol handler
> 
> This patch adds support for SAS Management Protocol (SMP) passthrough
> support via bsg.
> 
> Like libsas's smp support, user-space tools can send a smp request
> frame via sg_io_v4's dout_xferp and get a smp response frame via
> din_xferp. In addition, user-space tools can get the mpt reply via
> sg_io_v4's response field too if necessary.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Eric Moore <Eric.Moore@lsi.com>


