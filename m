From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] ipr: fix addition of abort command to HRRQ free queue
Date: Thu, 21 Mar 2013 08:52:35 -0500
Message-ID: <514B10A3.4010402@linux.vnet.ibm.com>
References: <20130314185222.994529433@linux.vnet.ibm.com> <20130314185803.296328943@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:38975 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab3CUNyL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Mar 2013 09:54:11 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 21 Mar 2013 07:54:10 -0600
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id F344338C804F
	for <linux-scsi@vger.kernel.org>; Thu, 21 Mar 2013 09:54:04 -0400 (EDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r2LDs4fb26935454
	for <linux-scsi@vger.kernel.org>; Thu, 21 Mar 2013 09:54:04 -0400
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r2LDqjSS031134
	for <linux-scsi@vger.kernel.org>; Thu, 21 Mar 2013 07:52:47 -0600
In-Reply-To: <20130314185803.296328943@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com

Patches 1-3 all look good. Thanks!

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


