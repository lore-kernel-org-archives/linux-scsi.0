From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 16/30] drivers/scsi/aic7xxx_old: Convert to generic
 boolean-values
Date: Mon, 7 May 2007 14:11:07 -0700
Message-ID: <20070507141107.e9c87d8c.akpm@linux-foundation.org>
References: <200704260735.l3Q7ZIj7024253@shell0.pdx.osdl.net>
	<1178567419.3729.44.camel@mulgrave.il.steeleye.com>
	<20070507140656.3debfb55.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564AbXEGVLk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 17:11:40 -0400
In-Reply-To: <20070507140656.3debfb55.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, ricknu-0@student.ltu.se

On Mon, 7 May 2007 14:06:56 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> so I'll drop it on those grounds, not on the bogus ones.

However it will come back again.  All subsystem-private implementations
of TRUE and FALSE are in the firing line now.
