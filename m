From: Christoph Hellwig <hch@infradead.org>
Subject: Re: "scsi: use host wide tags by default" causes uas regression
Date: Wed, 9 Mar 2016 10:26:03 -0800
Message-ID: <20160309182603.GA29246@infradead.org>
References: <56E06458.7040101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32794 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbcCIS0H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2016 13:26:07 -0500
Content-Disposition: inline
In-Reply-To: <56E06458.7040101@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI development list <linux-scsi@vger.kernel.org>, funnybutton@mailinator.com

On Wed, Mar 09, 2016 at 06:58:48PM +0100, Hans de Goede wrote:
> So my question is how do I tell the scsi layer to not submit more then X commands with
> scsi_init_shared_tag_map() gone ?

By setting ->can_queue in the Scsi_Host structure to the maximum number
of command you want outstanding for this host.
