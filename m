From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] ipr: Handle early EEH
Date: Wed, 12 Feb 2014 09:44:35 -0600
Message-ID: <52FB96E3.2090806@linux.vnet.ibm.com>
References: <20140121181638.007394972@linux.vnet.ibm.com> <20140121181746.707678592@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:43006 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaBLP6W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2014 10:58:22 -0500
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 12 Feb 2014 08:45:14 -0700
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 17F9019D807D
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2014 08:44:41 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08028.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1CFifQu7930132
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2014 16:44:41 +0100
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1CFie9c027404
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2014 08:44:40 -0700
In-Reply-To: <20140121181746.707678592@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: wenxiong@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

James,

Not sure if you were waiting for an ack for the third
in this series, since it came from me, but this whole
series is ready to get pulled in.

Acked-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


