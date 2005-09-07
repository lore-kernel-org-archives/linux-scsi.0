From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] SCSI target for IBM Power5 LPAR
Date: Wed, 7 Sep 2005 12:49:32 +0200
Message-ID: <20050907104932.GA14200@lst.de>
References: <20050906212801.GB14057@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:32413 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932107AbVIGKtr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 06:49:47 -0400
Content-Disposition: inline
In-Reply-To: <20050906212801.GB14057@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org, Santiago Leon <santil@us.ibm.com>, Linda Xie <lxiep@us.ibm.com>

On Tue, Sep 06, 2005 at 04:28:01PM -0500, Dave C Boutcher wrote:
> This device driver provides the SCSI target side of the "virtual
> SCSI" on IBM Power5 systems.  The initiator side has been in mainline
> for a while now (drivers/scsi/ibmvscsi/ibmvscsi.c.)  Targets already
> exist for AIX and OS/400.

Please try to integrate that with the generic scsi target framework at
http://developer.berlios.de/projects/stgt/.

