From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [patch 32/45] aic94xx: SATA tag mask not set correctly
Date: Fri, 20 Oct 2006 15:41:18 -0700
Message-ID: <4539508E.3000802@us.ibm.com>
References: <200610202148.k9KLmUJM004171@shell0.pdx.osdl.net>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:19409 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1422748AbWJTWlU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 18:41:20 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9KMfJaQ023973
	for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2006 18:41:19 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9KMfJKj362766
	for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2006 16:41:19 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9KMfJ2L021710
	for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2006 16:41:19 -0600
In-Reply-To: <200610202148.k9KLmUJM004171@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

akpm@osdl.org wrote:
> From: "Darrick J. Wong" <djwong@us.ibm.com>
> 
> The aic94xx controller has a bitmask establishing which tags are ok to use
> with a SATA NCQ disk.  When the queue depth is 32, however, the expression
> that is used sets the mask to zero, not 0xFFFFFFFF.  This patch widens the
> width of the integer so that this case is handled properly.

This patch is only useful if you have my SATA support patches for
libsas.  It lives in James Bottomley's aic94xx-sas-2.6 tree, so it'll go
in whenever the SATA stuff goes in.  That said, it won't hurt anything
to merge it now.

--D
