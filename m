From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Fri, 27 Jul 2007 17:24:19 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D708B3D8B@NAMAIL4.ad.lsil.com>
References: <20070726043933K.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51228 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758721AbXG0XYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 19:24:55 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070726043933K.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

On  Thursday, July 26, 2007 6:44 PM, FUJITA Tomonori wrote:
> 
> Does this work for you? Sorry, I'm not at the lab now and can't test
> it. But I can do next week.
> 
> I also updated bsg's smp_rep_manufacturer to print the mpi's
> replay. You can get it from the git tree.
> 

yes this will work, and I pulled the updated sgv4, and saw your
inclusion of mptsas.h.

Eric
