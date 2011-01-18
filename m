From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: remove EXTRA_CFLAGS
Date: Tue, 18 Jan 2011 12:59:16 -0800
Message-ID: <1295384356.22813.442.camel@haakon2.linux-iscsi.org>
References: <20110118202434.GA10884@lst.de>  <20110118202458.GB10884@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41565 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab1ARU7T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2011 15:59:19 -0500
In-Reply-To: <20110118202458.GB10884@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2011-01-18 at 21:24 +0100, Christoph Hellwig wrote:
> Add the current directory is superflous in general, and no includes in
> drivers/scsi are needed either.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Committed as c524eda into lio-core-2.6.git and picked into
scsi-post-merge-2.6.git/for-jejb.

Thanks!

--nab

