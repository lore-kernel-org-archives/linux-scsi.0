From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 14/30] cxlflash: Fix to avoid stall while waiting on
 TMF
Date: Mon, 21 Sep 2015 13:24:23 -0500
Message-ID: <56004B57.6080409@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1442439022-49742-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:55732 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbbIUSZW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2015 14:25:22 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 21 Sep 2015 12:25:21 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id BDAFF3E40048
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 12:25:16 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8LIM5C12490810
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 11:22:13 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8LIOgZ2027477
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 12:24:43 -0600
In-Reply-To: <1442439022-49742-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 09/16/2015 04:30 PM, Matthew R. Ochs wrote:
> Borrowing the TMF waitq's spinlock causes a stall condition when
> waiting for the TMF to complete. To remedy, introduce our own spin
> lock to serialize TMF and use the appropriate wait services.

Can you clarify what stall condition you were seeing. Its not obvious
to me what this fixes. Do you have softlockup logs from the failure?

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

