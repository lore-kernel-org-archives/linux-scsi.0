From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] scsi: Add EH Start Unit retry
Date: Mon, 02 Apr 2007 22:09:51 -0500
Message-ID: <1175569791.3680.94.camel@mulgrave.il.steeleye.com>
References: <11751999513070-patch-mail.ibm.com>
	 <460C375F.1000000@torque.net>  <46115234.20308@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36274 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751149AbXDCDKr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 23:10:47 -0400
In-Reply-To: <46115234.20308@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com

On Mon, 2007-04-02 at 13:57 -0500, Brian King wrote:
> I agree. The reason the ipr adapter firmware added this UA
> in this configuration was to support SCSI 1 reservations and
> communicate to the host that any reservation previously
> held to the disk array is now lost since the adapter was reset.

For that particular case, scsi_report_bus_reset() was the original
design concept ... it's asynchronous when the problem occurs ... if you
have to wait until UA, you don't necessarily find there's a problem
until much later.

James



