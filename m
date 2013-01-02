From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Fix several unlock issues in ipr driver
Date: Wed, 02 Jan 2013 16:36:25 -0600
Message-ID: <50E4B669.3000208@linux.vnet.ibm.com>
References: <20130102222637.134060560@linux.vnet.ibm.com> <20130102222700.693011987@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:51587 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3ABWgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2013 17:36:31 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 2 Jan 2013 15:36:30 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id A689919D803F
	for <linux-scsi@vger.kernel.org>; Wed,  2 Jan 2013 15:36:28 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r02MaSLj334130
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jan 2013 15:36:28 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r02MaRgG004420
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jan 2013 15:36:28 -0700
In-Reply-To: <20130102222700.693011987@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com

On 01/02/2013 04:26 PM, wenxiong@linux.vnet.ibm.com wrote:
> This patch fixes several unlock issues in ipr driver.

James - this fixes a couple regressions that were introduced in
the previous patch set.

Acked-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


