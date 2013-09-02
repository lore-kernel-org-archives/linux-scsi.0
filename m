From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] Disallow changing the device state via sysfs into
 "deleted"
Date: Mon, 2 Sep 2013 12:06:45 -0700
Message-ID: <20130902190645.GA18957@infradead.org>
References: <52135B99.2000102@acm.org>
 <52135C47.4090106@acm.org>
 <20130901164929.GD4344@infradead.org>
 <5224E012.6030907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34916 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3IBTHJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Sep 2013 15:07:09 -0400
Content-Disposition: inline
In-Reply-To: <5224E012.6030907@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Sep 02, 2013 at 08:59:30PM +0200, Bart Van Assche wrote:
> Do you agree with changing switch (state) into switch ((int)state) ?
> Without that additional change gcc reports the following warning:
> 
> drivers/scsi/scsi_sysfs.c: In function ?store_state_field?:
> drivers/scsi/scsi_sysfs.c:640:2: warning: case value ?0? not in
> enumerated type ?enum scsi_device_state? [-Wswitch]

Either that, or add a SDEV_INVALID_STATE = 0 value to the enum.  That
variant seems a little more elegant.

