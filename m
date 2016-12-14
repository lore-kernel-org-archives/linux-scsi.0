From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/22] qla2xxx: Refactor session management code.
Date: Wed, 14 Dec 2016 13:04:30 -0800
Message-ID: <20161214210430.GB1011@infradead.org>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-12-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52955 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753340AbcLNVEg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 16:04:36 -0500
Content-Disposition: inline
In-Reply-To: <1481056251-2310-12-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Tue, Dec 06, 2016 at 12:30:40PM -0800, Himanshu Madhani wrote:
>  9 files changed, 762 insertions(+), 474 deletions(-)

Again, a refactor that almost doubles the amount of code is a bad
one, please go back to the drawing board.
