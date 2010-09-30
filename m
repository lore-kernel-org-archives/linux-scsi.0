From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: fix array error logging
Date: Thu, 30 Sep 2010 10:44:31 -0500
Message-ID: <4CA4B05F.8020502@linux.vnet.ibm.com>
References: <20100927165904.645771561@linux.vnet.ibm.com> <4CA0CEE4.1050104@linux.vnet.ibm.com> <4CA0D838.20209@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49074 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab0I3PoV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2010 11:44:21 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o8UFOk8l004455
	for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2010 11:24:46 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o8UFiKDI325956
	for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2010 11:44:20 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o8UFiKU9031449
	for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2010 12:44:20 -0300
In-Reply-To: <4CA0D838.20209@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

On 09/27/2010 12:45 PM, Wayne Boyer wrote:
> The original patch was broken.  Here's the correct patch.
> 
> ---
> 
> The structure definitions for reporting array errors did not have the correct
> size for the Array WWID field.  This patch fixes those definitions.  It also
> fixes part of the output formatting that did not have newlines and fixes size
> calculations.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>

Acked-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


