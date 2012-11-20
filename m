From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/7] Add support for new IBM SAS controllers
Date: Tue, 20 Nov 2012 15:58:34 -0600
Message-ID: <50ABFD0A.4070405@linux.vnet.ibm.com>
References: <20121119213657.152897506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48615 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab2KTWAB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2012 17:00:01 -0500
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 20 Nov 2012 16:59:57 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 3C84038C8051
	for <linux-scsi@vger.kernel.org>; Tue, 20 Nov 2012 16:58:38 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qAKLwbv3302716
	for <linux-scsi@vger.kernel.org>; Tue, 20 Nov 2012 16:58:37 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qAKLwZtY012420
	for <linux-scsi@vger.kernel.org>; Tue, 20 Nov 2012 16:58:35 -0500
In-Reply-To: <20121119213657.152897506@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com

On 11/19/2012 03:36 PM, wenxiong@linux.vnet.ibm.com wrote:
> Hi all,
> 
> The new generation IBM SAS controllers will support MSI-X interrupt and
> Distributed Completion Processing features. The patches in this series
> add the code to support these new hardware features and also add some
> patches for performance improvement such as block iopoll and reducing
> lock contention in ipr driver.
> 
> Thanks for your help!
> Wendy
> 

Ack patches 1-7.

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


