From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API &
 Library)
Date: Wed, 25 Jan 2012 12:44:11 -0500
Message-ID: <20120125174411.GB12620@infradead.org>
References: <4F19A981.4080502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54097
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756429Ab2AYRoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 12:44:13 -0500
Content-Disposition: inline
In-Reply-To: <4F19A981.4080502@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Asleson <tasleson@redhat.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

There's another project which is creating a very ad-hoc storage
management abstraction, the nova-volume code in openstack.  Right now
it supports iSCSI with a few vendor-specific extensions for management,
RBD and sheepdog, but it looks like the numbers of vendors that want
to be supported is growing.

See https://github.com/openstack/nova/blob/master/nova/volume/driver.py
and other files in that directory for the little bits that exist at the
moment.

