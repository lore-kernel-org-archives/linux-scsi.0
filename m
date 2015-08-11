From: Christoph Hellwig <hch@lst.de>
Subject: Re: Persistent Reservation API
Date: Tue, 11 Aug 2015 14:26:34 +0200
Message-ID: <20150811122634.GA3035@lst.de>
References: <1438672271-11309-1-git-send-email-hch@lst.de> <20150811113041.68d9f122@g21.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39978 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933976AbbHKM0g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2015 08:26:36 -0400
Content-Disposition: inline
In-Reply-To: <20150811113041.68d9f122@g21.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Disseldorp <ddiss@suse.de>
Cc: linux-scsi@vger.kernel.org

Hi David,

if you want to add SCSI-2 RESERVE/RELEASE it would be at least
different opcodes if not an entirely different API.  But what for?
RESERVE/RELEASE are basially unsuable and that's why there are
almost no users out there, and they can usually prefer SCSI-3
semantics.

If you have a real users feel free to propose patches and I'm happy to
review them.
