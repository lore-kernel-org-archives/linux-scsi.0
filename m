From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 14157] end_request: I/O error, dev cciss/cXdX, sector 0
Date: Sun, 13 Sep 2009 19:08:40 -0500
Message-ID: <1252886920.23599.17.camel@mulgrave.site>
References: <bug-14157-11613@http.bugzilla.kernel.org/>
	 <200909132240.n8DMe5as029877@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbZINAIv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Sep 2009 20:08:51 -0400
In-Reply-To: <200909132240.n8DMe5as029877@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

> --- Comment #2 from Andrew Morton <akpm@linux-foundation.org>  2009-09-13 22:40:04 ---
> Marked as a regression.
> 
> Randomly reassigned to block layer.
> 
> Weird.

It's theoretically possible, I suppose, but no-one else is seeing this.
It sounds like some local config setup issue, which a full dmesg might
shed some light on ... say some protected area on sector 0 or something.

James


