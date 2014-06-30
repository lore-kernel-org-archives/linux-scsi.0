From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH 2/4] Introduce xen-scsifront module
Date: Mon, 30 Jun 2014 14:35:49 +0100
Message-ID: <53B167B5.7070104@citrix.com>
References: <1403879676-25431-1-git-send-email-jgross@suse.com> <1403879676-25431-3-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.citrix.com ([66.165.176.89]:32271 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbaF3Nfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jun 2014 09:35:55 -0400
In-Reply-To: <1403879676-25431-3-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org

On 27/06/14 15:34, jgross@suse.com wrote:
> 
> +/*	.resume			= scsifront_resume, */

Following on from the recent discussion on migration with front/backends
I thought I'd review how this new driver does it.

Is there an expectation that a VM with a PV scsi device cannot be
restored or migrated?

David
