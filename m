From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v6 13/37] cxlflash: Fix to avoid stall while waiting on
 TMF
Date: Fri, 23 Oct 2015 15:36:48 +0200
Message-ID: <562A37F0.4040201@redhat.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1445458401-3279-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbbJWNgv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Oct 2015 09:36:51 -0400
In-Reply-To: <1445458401-3279-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 21.10.2015 22:13, Matthew R. Ochs wrote:
> Borrowing the TMF waitq's spinlock causes a stall condition when
> waiting for the TMF to complete. To remedy, introduce our own spin
> lock to serialize TMF and use the appropriate wait services.
>
> Also add a timeout while waiting for a TMF completion. When a TMF
> times out, report back a failure such that a bigger hammer reset
> can occur.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

