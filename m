From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH] fnic: use DMA_BIT_MASK(nn) instead of deprecated
 DMA_nnBIT_MASK
Date: Wed, 24 Jun 2009 15:02:43 -0700
Message-ID: <1245880963.3359.89.camel@fritz>
References: <20090624144151.9087.71898.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59284 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbZFXWCk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jun 2009 18:02:40 -0400
In-Reply-To: <20090624144151.9087.71898.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jeykholt@cisco.com" <jeykholt@cisco.com>

On Wed, 2009-06-24 at 07:42 -0700, Abhijeet Joglekar wrote:
> Robert Love reported warning while building fnic_main.c:
> drivers/scsi/fnic/fnic_main.c:478: warning: `DMA_nnBIT_MASK' is deprecated.
> 
> Replaced use of DMA_nnBIT_MASK by DMA_BIT_MASK(nn)
> 
This resolves the warning that I was seeing.

> Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>

This may be too trivial for something like this, but anyway-

Tested-by: Robert Love <robert.w.love@intel.com>


