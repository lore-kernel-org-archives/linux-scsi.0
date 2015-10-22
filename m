From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 36/37] cxlflash: Fix to avoid lock instrumentation
 rejection
Date: Thu, 22 Oct 2015 12:34:27 -0500
Message-ID: <56291E23.6010406@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1445458584-63347-1-git-send-email-mrochs@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:38713 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400AbbJVReV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Oct 2015 13:34:21 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 22 Oct 2015 11:34:20 -0600
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 2F3F36E8053
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2015 13:22:28 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9MHYGBv55116002
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2015 17:34:16 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9MHYE6H017365
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2015 13:34:16 -0400
In-Reply-To: <1445458584-63347-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org

Acked-by: Manoj Kumar <manoj@linux.vnet.ibm.com>

On 10/21/2015 3:16 PM, Matthew R. Ochs wrote:
> When running with lock instrumentation (e.g. lockdep), some of the
> instrumentation can become disabled at probe time for a cxlflash
> adapter. This is due to a missing lock registration for the tmf_slock.
>
> The fix is to call spin_lock_init() for the tmf_slock during probe.

