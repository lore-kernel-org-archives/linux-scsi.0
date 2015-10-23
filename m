From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v6 18/37] cxlflash: Fix AFU version access/storage and add
 check
Date: Fri, 23 Oct 2015 15:40:08 +0200
Message-ID: <562A38B8.3060705@redhat.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1445458441-21416-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbbJWNkM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Oct 2015 09:40:12 -0400
In-Reply-To: <1445458441-21416-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 21.10.2015 22:14, Matthew R. Ochs wrote:
> The AFU version is stored as a non-terminated string of bytes within
> a 64-bit little-endian register. Presently the value is read directly
> (no MMIO accessor) and is stored in a buffer that is not big enough
> to contain a NULL terminator. Additionally the version obtained is not
> evaluated against a known value to prevent usage with unsupported AFUs.
> All of these deficiencies can lead to a variety of problems.
>
> To remedy, use the correct MMIO accessor to read the version value into
> a null-terminated buffer and add a check to prevent an incompatible AFU
> from being used with this driver.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
> Reviewed-by: Daniel Axtens <dja@axtens.net>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

