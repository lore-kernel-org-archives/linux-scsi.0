From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] isci: remove base_request abstraction
Date: Fri, 1 Apr 2011 09:11:13 -0400
Message-ID: <20110401131113.GB27181@infradead.org>
References: <20110328000754.GA28347@infradead.org>
 <20110328132046.GA497@infradead.org>
 <20110328132114.GB11684@infradead.org>
 <AANLkTinTFY69L67u2qZpyUWmDOqGFy7ePMdwb2dVWFKi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1DANLO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2011 09:11:14 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinTFY69L67u2qZpyUWmDOqGFy7ePMdwb2dVWFKi@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Thu, Mar 31, 2011 at 03:14:14PM -0700, Dan Williams wrote:
> We'll want to do a tree-wide s/sci_base_/sci_/, but maybe not until we
> settle on the final unified object names... put it off for now.

I don't think much of the sci_base names will be left, basically just
the core state machine helpers.

