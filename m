From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v6 36/37] cxlflash: Fix to avoid lock instrumentation
 rejection
Date: Fri, 23 Oct 2015 14:22:19 +1100
Message-ID: <5629A7EB.5060207@au1.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com> <1445458584-63347-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:50279 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbbJWDWw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Oct 2015 23:22:52 -0400
Received: from /spool/local
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Fri, 23 Oct 2015 13:22:49 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 2AE9B2CE8056
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2015 14:22:46 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9N3MWX231916282
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2015 14:22:41 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9N3MCXx001275
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2015 14:22:13 +1100
In-Reply-To: <1445458584-63347-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 22/10/15 07:16, Matthew R. Ochs wrote:
> When running with lock instrumentation (e.g. lockdep), some of the
> instrumentation can become disabled at probe time for a cxlflash
> adapter. This is due to a missing lock registration for the tmf_slock.
>
> The fix is to call spin_lock_init() for the tmf_slock during probe.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

-- 
Andrew Donnellan              Software Engineer, OzLabs
andrew.donnellan@au1.ibm.com  Australia Development Lab, Canberra
+61 2 6201 8874 (work)        IBM Australia Limited

