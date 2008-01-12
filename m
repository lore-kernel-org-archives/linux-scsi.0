From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] fix the sysfs_add_file_to_group interfaces
Date: Fri, 11 Jan 2008 21:11:44 -0800
Message-ID: <20080112051144.GC19894@kroah.com>
References: <1199321045.3258.91.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57816 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYALFU6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jan 2008 00:20:58 -0500
Content-Disposition: inline
In-Reply-To: <1199321045.3258.91.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Jan 02, 2008 at 06:44:05PM -0600, James Bottomley wrote:
> I can't see a reason why these shouldn't work on every group.  However,
> they only seem to work on named groups.  This patch allows the group
> functions to work on anonymous groups (those with NULL names).
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Feel free to add:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
and take it through your tree.

thanks,

greg k-h
