From: David Disseldorp <ddiss@suse.de>
Subject: Re: Persistent Reservation API
Date: Tue, 11 Aug 2015 14:52:35 +0200
Message-ID: <20150811145235.01c9cbc0@g21.suse.de>
References: <1438672271-11309-1-git-send-email-hch@lst.de>
	<20150811113041.68d9f122@g21.suse.de>
	<20150811122634.GA3035@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934106AbbHKMwh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2015 08:52:37 -0400
In-Reply-To: <20150811122634.GA3035@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 11 Aug 2015 14:26:34 +0200, Christoph Hellwig wrote:

> if you want to add SCSI-2 RESERVE/RELEASE it would be at least
> different opcodes if not an entirely different API.  But what for?
> RESERVE/RELEASE are basially unsuable and that's why there are
> almost no users out there, and they can usually prefer SCSI-3
> semantics.

IIUC, recent versions of ESX can still fall-back to using SCSI-2
reservations[1].
With COMPARE AND WRITE supported by LIO, I expect SCSI-2 reservations
are no longer strictly needed, but they haven't been dropped yet.

> If you have a real users feel free to propose patches and I'm happy to
> review them.

Thanks, David

1. http://linux-iscsi.org/wiki/VStorage_APIs_for_Array_Integration
