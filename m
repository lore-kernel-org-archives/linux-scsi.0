From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v5 10/34] cxlflash: Make functions static
Date: Fri, 2 Oct 2015 15:16:03 +0200
Message-ID: <560E8393.6060904@redhat.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443714936-15625-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbbJBNQH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 09:16:07 -0400
In-Reply-To: <1443714936-15625-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 1.10.2015 17:55, Matthew R. Ochs wrote:
> Found during code inspection, that the following functions are not
> being used outside of the file where they are defined. Make them static.
>
> int cxlflash_send_cmd(struct afu *, struct afu_cmd *);
> void cxlflash_wait_resp(struct afu *, struct afu_cmd *);
> int cxlflash_afu_reset(struct cxlflash_cfg *);
> struct afu_cmd *cxlflash_cmd_checkout(struct afu *);
> void cxlflash_cmd_checkin(struct afu_cmd *);
> void init_pcr(struct cxlflash_cfg *);
> int init_global(struct cxlflash_cfg *);
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

