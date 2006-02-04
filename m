From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8]  fusion - mptctl - Event Log Fix
Date: Sat, 4 Feb 2006 11:04:54 +0000
Message-ID: <20060204110454.GC27621@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F243698@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9697 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1946154AbWBDLEz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Feb 2006 06:04:55 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F243698@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Feb 02, 2006 at 05:19:40PM -0700, Moore, Eric wrote:
> Use the hard coded value MPTCTL_EVENT_LOG_SIZE to fix
> bug where in certain cases, the ioc->eventLogSize was 
> initialized.

ok.  but with this patch applied ioc->eventLogSize is only initialized but
never used, so you should just kill it.

