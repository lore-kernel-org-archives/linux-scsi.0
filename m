From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/15] bfa: Introduced initiator based lun masking
 feature.
Date: Sun, 21 Aug 2011 11:57:32 -0400
Message-ID: <20110821155732.GA26519@infradead.org>
References: <1311206643-13045-1-git-send-email-kgudipat@brocade.com>
 <4E4D9C3A.1030903@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40355
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209Ab1HUP5m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2011 11:57:42 -0400
Content-Disposition: inline
In-Reply-To: <4E4D9C3A.1030903@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: kgudipat@brocade.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, huangj@brocade.com, adapter_linux_open_src_team@brocade.com

On Thu, Aug 18, 2011 at 06:11:54PM -0500, Mike Christie wrote:
> We do not really want drivers doing lun masking do we? This patch seems
> wrong on so many levels. Drivers should not be doing lun masking. It
> should go into something like scsi-ml and be a common interface. If it
> was implemented in drivers it seems like it should take advantage of the
> slave callouts instead of faking sense.

Agreed on all counts.  This needs to be done properly.

