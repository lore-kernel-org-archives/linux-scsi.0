From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: do not include target_core_mib.h under
	include/target
Date: Tue, 18 Jan 2011 12:58:31 -0800
Message-ID: <1295384311.22813.440.camel@haakon2.linux-iscsi.org>
References: <20110118202434.GA10884@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41561 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1ARU6f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2011 15:58:35 -0500
In-Reply-To: <20110118202434.GA10884@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2011-01-18 at 21:24 +0100, Christoph Hellwig wrote:
> Headers under include/ should not include headers that require a specific
> include path.  Fix this by moving the defintion of scsi_port_stats to
> target_core_base.h, and including target_core_mib.h directly where needed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks Christoph..  Committed as 0080d7d into lio-core-2.6.git and
picked into scsi-post-merge-2.6.git/for-jejb.

--nab


