From: Christoph Hellwig <hch@infradead.org>
Subject: Re: "scsi: use host wide tags by default" causes uas regression
Date: Wed, 9 Mar 2016 10:31:10 -0800
Message-ID: <20160309183110.GA8415@infradead.org>
References: <56E06458.7040101@redhat.com>
 <20160309182603.GA29246@infradead.org>
 <56E06B36.4010204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33004 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836AbcCISbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2016 13:31:11 -0500
Content-Disposition: inline
In-Reply-To: <56E06B36.4010204@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, funnybutton@mailinator.com

On Wed, Mar 09, 2016 at 07:28:06PM +0100, Hans de Goede wrote:
> >By setting ->can_queue in the Scsi_Host structure to the maximum number
> >of command you want outstanding for this host.
> 
> Can I lower this after calling scsi_host_alloc(), or do I need to make
> my template "dynamic" ?

You don't need to set in the host template, you can set it directly
in the Scsi_Host structure. It needs to be set before scsi_add_host,
though.
