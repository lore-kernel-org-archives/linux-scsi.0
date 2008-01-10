From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: question on sd_open()
Date: Thu, 10 Jan 2008 14:40:59 +0000
Message-ID: <20080110144059.GC27894@ZenIV.linux.org.uk>
References: <200801092155.16112.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51847 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYAJOlF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 09:41:05 -0500
Content-Disposition: inline
In-Reply-To: <200801092155.16112.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Jan 09, 2008 at 09:55:15PM +0100, Oliver Neukum wrote:
> Hello,
> 
> is there a way to distinguish calls to sd_open() from mount() from
> calls to open() ?

No.  And there's no way to tell opening external log from either.  Or
from swapon.  Why the hell would the driver care?
