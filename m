From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/0] scsi_cmnd accessors issues
Date: Thu, 14 Jun 2007 19:26:45 +0300
Message-ID: <46716C45.1090107@panasas.com>
References: <466EDFAC.9020104@panasas.com>	<20070613085118P.fujita.tomonori@lab.ntt.co.jp>	<E472128B1EB43941B4E7FB268020C89B0250B912@riverside.int.panasas.com> <20070613194513H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:56999 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750873AbXFNQ1B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 12:27:01 -0400
In-Reply-To: <20070613194513H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ed Lin <ed.lin@promise.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> 
> There are just two llds. I suspect that we can fix them. Or they can
> access to the data directly (without the accessors) if we can't.
> 
> I don't think that introducing something like scsi_set_sg_count, which
> is meaningless to most of llds, is a good idea.

Following are 3 patches for fixing the l-value issues for accessors.

0/1 - proposed new accessors which will not let l-value code compile.
0/2 - Clean fix of drivers/scsi/tmscsim.c to not need setting of sg_count
0/3 - In drivers/scsi/stex.c open code of write access to request_bufflen.
      when new code is committed this driver will have to change with it.


