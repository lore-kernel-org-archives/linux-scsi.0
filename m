From: Santiago Leon <sleon@vt.edu>
Subject: Re: [PATCH 2/2] ibmvscsi: add slave_configure to allow device restart
Date: Mon, 12 Feb 2007 09:42:23 -0600
Message-ID: <45D08ADF.5010703@vt.edu>
References: <20070209174949.5080.69663.sendpatchset@toy> <20070209175000.5080.69780.sendpatchset@toy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-05.texas.rr.com ([24.93.47.44]:60118 "EHLO
	ms-smtp-05.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010AbXBLPlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2007 10:41:18 -0500
Received: from [192.168.0.100] (cpe-66-69-212-176.austin.res.rr.com [66.69.212.176])
	by ms-smtp-05.texas.rr.com (8.13.6/8.13.6) with ESMTP id l1CFfH8V000406
	for <linux-scsi@vger.kernel.org>; Mon, 12 Feb 2007 09:41:17 -0600 (CST)
In-Reply-To: <20070209175000.5080.69780.sendpatchset@toy>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Robert Jennings wrote:
> Adding a slave_configure function for the driver. Now the disks can be
> restarted by the scsi mid-layer when the are disconnected and reconnected.

Signed-off-by: Santiago Leon <santil@us.ibm.com>

> Signed-off-by: "Robert Jennings" <rcj@linux.vnet.ibm.com>


