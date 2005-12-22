From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] aic7xxx: New device ids
Date: Thu, 22 Dec 2005 18:07:51 +0000
Message-ID: <20051222180751.GA7417@infradead.org>
References: <43AAB4B6.3040403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:4330 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030250AbVLVSHy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 13:07:54 -0500
Content-Disposition: inline
In-Reply-To: <43AAB4B6.3040403@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> - * Copyright (c) 1994-2001 Justin T. Gibbs.
> + * Copyright (c) 1994-2000 Justin T. Gibbs.

reverting copyright years is very unpolite.

>  #else
> +#include <sys/cdefs.h>
> +__FBSDID("$FreeBSD$");

please don't put new freebsd gunk in.

