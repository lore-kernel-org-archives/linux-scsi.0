From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/11] mpt2sas v00.100.11.11 : mpt2sas_base sources
Date: Fri, 06 Mar 2009 18:57:03 +0000
Message-ID: <1236365823.12019.9.camel@localhost.localdomain>
References: <20090304050759.GB4194@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50670 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579AbZCFS5H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2009 13:57:07 -0500
In-Reply-To: <20090304050759.GB4194@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2009-03-03 at 22:08 -0700, Eric Moore wrote:
> +/* base shared API */
> +extern struct list_head ioc_list;
> +
> +int base_attach(struct MPT2SAS_ADAPTER *ioc);
> +void base_detach(struct MPT2SAS_ADAPTER *ioc);

This is rather generic to be in the global namespace.

> +/* config shared API */
> +void config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32
> reply);

And this.

> +void ctl_init(void);
> +void ctl_exit(void);
> +void ctl_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32
> reply);

Ditto this.

Would it not be better to have a mpt2sas_ prefix added to all the
non-static symbols?

James


