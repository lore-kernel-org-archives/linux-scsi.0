From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [OpenFCoE PATCH] If expecting pre-T11 frames, a T11 frame
	caused a data fault.
Date: Wed, 5 Dec 2007 13:55:43 +0000
Message-ID: <20071205135543.GA2174@infradead.org>
References: <20071205005214.26211.62814.stgit@mink.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52251 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXLENzp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 08:55:45 -0500
Content-Disposition: inline
In-Reply-To: <20071205005214.26211.62814.stgit@mink.he.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <fcoe@eykholt.com>
Cc: linux-scsi@vger.kernel.org

Just wondering:

>From my quick reading of the code these pre-T11 frames are basically
a different frame-level protocol.  Given that T11 has standardized
on a different one what's the rationale for supporting the old frames?

