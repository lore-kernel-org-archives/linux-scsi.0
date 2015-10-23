From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v6 31/37] cxlflash: Correct trace string
Date: Fri, 23 Oct 2015 16:00:18 +0200
Message-ID: <562A3D72.9010101@redhat.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1445458545-60620-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbbJWOAX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Oct 2015 10:00:23 -0400
In-Reply-To: <1445458545-60620-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 21.10.2015 22:15, Matthew R. Ochs wrote:
> The trace following the failure of alloc_mem() incorrectly identifies
> which function failed. This can lead to misdiagnosing a failure.
>
> Fix the string to correctly indicate that alloc_mem() failed.
>
> Reported-by: Brian King <brking@linux.vnet.ibm.com>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
> Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

