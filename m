From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v6 19/37] cxlflash: Correct usage of scsi_host_put()
Date: Fri, 23 Oct 2015 15:41:03 +0200
Message-ID: <562A38EF.7020104@redhat.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1445458449-22858-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbbJWNlH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Oct 2015 09:41:07 -0400
In-Reply-To: <1445458449-22858-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 21.10.2015 22:14, Matthew R. Ochs wrote:
> Currently, scsi_host_put() is being called prematurely in the
> remove path and is missing entirely in an error cleanup path.
> The former can lead to memory being freed too early with
> subsequent access potentially corrupting data whilst the former
> would result in a memory leak.
>
> Move the usage on remove to be the last cleanup action taken
> and introduce a call to scsi_host_put() in the one initialization
> error path that does not use remove to cleanup.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

