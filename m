From: Christoph Hellwig <hch@infradead.org>
Subject: Re: patch so cciss stats are collected in /proc/stat
Date: Wed, 29 Sep 2004 17:19:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929171926.A14606@infradead.org>
References: <20040929161345.GB22308@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:44292 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268700AbUI2QTl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 12:19:41 -0400
Content-Disposition: inline
In-Reply-To: <20040929161345.GB22308@beardog.cca.cpqcorp.net>; from mike.miller@hp.com on Wed, Sep 29, 2004 at 11:13:45AM -0500
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com, mikem@beardog.cca.cpqcorp.net
Cc: marcelo.tosatti@cyclades.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, brian.b@hp.com

On Wed, Sep 29, 2004 at 11:13:45AM -0500, mike.miller@hp.com wrote:
> Currently cciss statistics are not collected in /proc/stat. This patch
> bumps DK_MAX_MAJOR to 111 to fix that. This has been a common complaint
> by customers wishing to gather info about cciss devices.
> Please consider this for inclusion. Applies to 2.4.28-pre3.

This patch has been reject about half a million times, why are people
submitting it again and again?

You get more detailed statistics in /proc/partitions.

