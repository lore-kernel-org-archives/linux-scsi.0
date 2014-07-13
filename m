From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] iscsi: iscsi changes for 3.17
Date: Sun, 13 Jul 2014 02:50:03 -0700
Message-ID: <20140713095003.GA19682@infradead.org>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaGMJuF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 05:50:05 -0400
Content-Disposition: inline
In-Reply-To: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Sat, Jul 12, 2014 at 03:51:47PM -0500, michaelc@cs.wisc.edu wrote:
> The following patches were made over Chrisoph's scsi-queue drivers-for-3.17
> branch. They are some fixes to the get_host_stats code and new error code
> for when a iscsi ping times out.

The series looks fine to me, I'll merge it as soon as I get the
remaining second reviews.

