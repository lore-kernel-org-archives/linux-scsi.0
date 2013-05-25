From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] scsi_transport_fc: FC timeout handler
Date: Sat, 25 May 2013 01:08:42 -0400
Message-ID: <20130525050842.GA6973@infradead.org>
References: <1369389050-118628-1-git-send-email-hare@suse.de>
 <1369389050-118628-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41177
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959Ab3EYFIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 May 2013 01:08:47 -0400
Content-Disposition: inline
In-Reply-To: <1369389050-118628-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>

This looks like a good start, but why would we make this FC specific?

