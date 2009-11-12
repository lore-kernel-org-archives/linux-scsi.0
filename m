From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 04/17] Fix use of unallocated memory for MSA2xxx
 enclosure device data.
Date: Thu, 12 Nov 2009 14:45:24 -0800
Message-ID: <20091112144524.dc254708.akpm@linux-foundation.org>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
	<20091111165043.17754.6076.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731AbZKLWp3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Nov 2009 17:45:29 -0500
In-Reply-To: <20091111165043.17754.6076.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com

On Wed, 11 Nov 2009 10:50:43 -0600
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> +#define MAX_MSA2XXX_ENCLOSURES 32
> +	if (*nmsa2xxx_enclosures >= MAX_MSA2XXX_ENCLOSURES) {
> +		dev_warn(&h->pdev->dev, "Maximum number of MSA2XXX "
> +			"enclosures exceeded.  Check your hardware "
> +			"configuration.");
> +		return 0;
> +	}

The message would be a bit more helpful if it told the operator what the
limit actually is.
