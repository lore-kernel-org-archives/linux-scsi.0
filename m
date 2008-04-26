From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11 of 16] Move scsi_disk() accessor function to sd.h
Date: Sat, 26 Apr 2008 02:23:47 -0400
Message-ID: <20080426062347.GA1081@infradead.org>
References: <patchbomb.1209165122@sermon.lab.mkp.net> <b512cd02f8b0de20d093.1209165133@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYDZGXs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Apr 2008 02:23:48 -0400
Content-Disposition: inline
In-Reply-To: <b512cd02f8b0de20d093.1209165133@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 25, 2008 at 07:12:13PM -0400, Martin K. Petersen wrote:
> 2 files changed, 5 insertions(+), 5 deletions(-)
> drivers/scsi/sd.c |    5 -----
> include/scsi/sd.h |    5 +++++

Nack.  Creating of sd.h was a big mistake already and should be reverse.
No one but sd.c has any business playing with these.

