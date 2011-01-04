From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [patch] [SCSI] scsi_dh: potential null dereference in
 scsi_dh_activate()
Date: Tue, 04 Jan 2011 10:24:39 -0600
Message-ID: <1294158279.4726.17.camel@mulgrave.site>
References: <20110103054833.GT1886@bicker>
	 <E463DF2B2E584B4A82673F53D62C2EF4F5582F42@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1ADQYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2011 11:24:45 -0500
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4F5582F42@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: Dan Carpenter <error27@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Menny Hamburger <Menny_Hamburger@Dell.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

On Tue, 2011-01-04 at 09:13 -0700, Moger, Babu wrote:
> Looks good to me.

It does?  The first check is the bogus one, surely.  The queue is
created and destroyed by scsi_alloc_sdev(), so queuedata can never be
NULL for a SCSI queue.  There's no check anywhere in the rest of SCSI,
so there shouldn't be one here, should there?

James


