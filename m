From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v4 02/32] cxlflash: Replace magic numbers with literals
Date: Tue, 29 Sep 2015 15:40:58 +1000
Message-ID: <560A246A.9000101@au1.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443222742-8995-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56990 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbbI2Flj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2015 01:41:39 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Tue, 29 Sep 2015 15:41:37 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id E39303578052
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:41:32 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8T5fQxZ65929272
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:41:34 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8T5exGG030902
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:41:00 +1000
In-Reply-To: <1443222742-8995-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Manoj Kumar <kumarmn@us.ibm.com>, Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 26/09/15 09:12, Matthew R. Ochs wrote:
> From: Manoj Kumar <kumarmn@us.ibm.com>
>
> Magic numbers are not meaningful and can create confusion. As a
> remedy, replace them with descriptive literals.
>
> Replace 512 with literal MAX_SECTOR_UNIT.
> Replace 5 with literal CMD_RETRIES.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

-- 
Andrew Donnellan              Software Engineer, OzLabs
andrew.donnellan@au1.ibm.com  Australia Development Lab, Canberra
+61 2 6201 8874 (work)        IBM Australia Limited

