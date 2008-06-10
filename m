From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2 of 7] block: Globalize bio_set and bio_vec_slab
Date: Tue, 10 Jun 2008 14:55:43 -0400
Message-ID: <x49iqwh9l1s.fsf@segfault.boston.devel.redhat.com>
References: <550d61001baa70aebab7.1212814535@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYFJS4B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2008 14:56:01 -0400
In-Reply-To: <550d61001baa70aebab7.1212814535@sermon.lab.mkp.net> (Martin
	K. Petersen's message of "Sat, 07 Jun 2008 00:55:35 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

> 2 files changed, 38 insertions(+), 28 deletions(-)
> fs/bio.c            |   36 ++++++++----------------------------
> include/linux/bio.h |   30 ++++++++++++++++++++++++++++++
>
>
> Move struct bio_set and biovec_slab definitions to bio.h so they can
> be used outside of bio.c.

Don't sell yourself short;  you also implemented bvec_nr_vecs.

Looks okay to me.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
