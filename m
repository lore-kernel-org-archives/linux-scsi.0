From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] scsi: allow to increase the maximum number of sg entries
Date: Wed, 18 Apr 2007 07:32:03 -0400
Message-ID: <1176895924.3671.100.camel@mulgrave.il.steeleye.com>
References: <20070418082114.GE13565@lombardij>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57986 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422861AbXDRLcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2007 07:32:11 -0400
In-Reply-To: <20070418082114.GE13565@lombardij>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johann Lombardi <johann.lombardi@bull.net>
Cc: linux-scsi@vger.kernel.org

On Wed, 2007-04-18 at 10:21 +0200, Johann Lombardi wrote:
> We have observed noticeable performance improvement by using large single
> command data transfers (up to 4MB) with some storage subsystems such as DDN's.
> The patch below adds a new config option (CONFIG_SCSI_LARGE_SG) which allows to
> increase SCSI_MAX_PHYS_SEGMENTS. When enabled, we should get 4MB transfers even
> if the buffers are completely fragmented in physical memory.
> Thanks in advance for any comments.

I don't think so: simply increasing the phys segments has no effect on a
fully fragmented sg list if the hw segments doesn't go up to match it.

Since changing the hw segments necessitates driver work, I'd really like
to see justification in terms of throughput figures versus transfer size
rather than vague assertions that bigger is better.

James


