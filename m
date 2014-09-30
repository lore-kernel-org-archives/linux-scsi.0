From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] iscsi patches for 3.18
Date: Tue, 30 Sep 2014 06:46:59 -0700
Message-ID: <20140930134659.GD26479@infradead.org>
References: <1412016942-4759-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36724 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaI3Nq7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 09:46:59 -0400
Content-Disposition: inline
In-Reply-To: <1412016942-4759-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Mon, Sep 29, 2014 at 01:55:40PM -0500, michaelc@cs.wisc.edu wrote:
> A couple patches made over the scsi-queue drivers-for-3.18 branch.
> They just fix a possible bug with be2iscsi that Dan reported and
> also export the iscsi port being used.

Thanks, applied both patches to drivers-for-3.18.

