From: Kyle McMartin <kyle@infradead.org>
Subject: Re: iscsi_add_session() warning
Date: Tue, 3 Feb 2009 19:12:38 -0500
Message-ID: <20090204001238.GG19327@bombadil.infradead.org>
References: <20090203160900.38506c47.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZBDAMp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2009 19:12:45 -0500
Content-Disposition: inline
In-Reply-To: <20090203160900.38506c47.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On Tue, Feb 03, 2009 at 04:09:00PM -0800, Andrew Morton wrote:
> : 	if (id == ISCSI_MAX_TARGET) {
> : 		for (id = 0; id < ISCSI_MAX_TARGET; id++) {
> : 			err = device_for_each_child(&shost->shost_gendev, &id,

Possibly GCC just can't figure out that id was reinitialized, so it
thinks that the for loop won't be executed?

Just a guess...
	Kyle
