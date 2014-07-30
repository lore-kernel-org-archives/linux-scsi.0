From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] iscsi: iscsi changes for 3.17
Date: Wed, 30 Jul 2014 04:43:41 -0700
Message-ID: <20140730114341.GA18657@infradead.org>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaG3Lnr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2014 07:43:47 -0400
Content-Disposition: inline
In-Reply-To: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, Tomas Henzl <thenzl@redhat.com>, Hannes Reinecke <hare@suse.de>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: linux-scsi@vger.kernel.org

Can I get reviews for the remaining patches, please?

On Sat, Jul 12, 2014 at 03:51:47PM -0500, michaelc@cs.wisc.edu wrote:
> The following patches were made over Chrisoph's scsi-queue drivers-for-3.17
> branch. They are some fixes to the get_host_stats code and new error code
> for when a iscsi ping times out.
> 
> Note for applying/merging:
> 
> The patches also apply over James's scsi misc branch, but that branch
> is missing some patches that Chrisoph has picked up.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
