From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3]: IO resource allocation using
	pci_request_selected_regions API
Date: Fri, 11 Jan 2008 09:28:18 +0000
Message-ID: <20080111092818.GA16566@infradead.org>
References: <20080111090330.GA4161@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33134 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbYAKJ2U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 04:28:20 -0500
Content-Disposition: inline
In-Reply-To: <20080111090330.GA4161@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Fri, Jan 11, 2008 at 02:33:30PM +0530, Prakash, Sathya wrote:
> This patch modifies the IO resource allocation behavior of FUSION driver. 
> By using the pci_select_bars and pci_request_selected_regions API
> The IORESOURCE_IO will be requested only when the driver needs the IO resource.

Didn't benh or someone else just replace pci_request_selected_regions
with a less braindead API?

