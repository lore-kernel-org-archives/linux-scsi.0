From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC][PATCH] Coding style fix drivers/scsi/mvme147.c
Date: Wed, 1 Aug 2007 09:20:07 -0600
Message-ID: <20070801152007.GA21219@parisc-linux.org>
References: <46B0A3FB.2080701@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34092 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763427AbXHAPUJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 11:20:09 -0400
Content-Disposition: inline
In-Reply-To: <46B0A3FB.2080701@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Wed, Aug 01, 2007 at 05:17:15PM +0200, Michal Piotrowski wrote:
> -#include<linux/stat.h>
> +#include <linux/stat.h>

Why does this driver need stat.h at all?

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
