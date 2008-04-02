From: Greg KH <greg@kroah.com>
Subject: Re: transport_class: BUG if we can't release the attribute
	container
Date: Wed, 2 Apr 2008 07:54:36 -0700
Message-ID: <20080402145436.GC29318@kroah.com>
References: <1206203957.4393.16.camel@localhost.localdomain> <20080402063232.GD8158@kroah.com> <1207145753.3082.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40875 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbYDBOyt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 10:54:49 -0400
Content-Disposition: inline
In-Reply-To: <1207145753.3082.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Apr 02, 2008 at 09:15:53AM -0500, James Bottomley wrote:
> > If you change that, I have no problem with this.
> 
> OK ... your subsystem tree your call, I suppose.  How about the
> attached.

No, you only changed one instance.  Can you please change them all?

thanks,

greg k-h
