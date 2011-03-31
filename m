From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scic: remove mmio wrappers
Date: Thu, 31 Mar 2011 02:31:14 -0400
Message-ID: <20110331063114.GB32336@infradead.org>
References: <20110328000754.GA28347@infradead.org>
 <AANLkTinqdo6q_EUCih74iZzsiccL1V-nk8qatxRVY8ax@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45180 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab1CaGbP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2011 02:31:15 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinqdo6q_EUCih74iZzsiccL1V-nk8qatxRVY8ax@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Wed, Mar 30, 2011 at 06:43:45PM -0700, Dan Williams wrote:
> Smoketests ok, applied, but without the hunk below, which gives away
> the fact that this was automated to some extent.

This wasn't automated, but I don't think leaving stale references to
macros that have been removed is a good idea.  Which btw is something
that can be seen a lot in the current codebase - there's tons of
comments referring to non-existing types.  But most of these are rather
pointless boilerplates explaining the signatures operation vectors the 
Nth time.

