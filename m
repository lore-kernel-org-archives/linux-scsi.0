From: Christoph Hellwig <hch@lst.de>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs take 2
Date: Mon, 6 Sep 2004 16:32:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040906143251.GB21646@lst.de>
References: <413557CB.8010008@cs.wisc.edu> <20040901162042.GC26753@null.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:39556 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268070AbUIFOdA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 10:33:00 -0400
Content-Disposition: inline
In-Reply-To: <20040901162042.GC26753@null.msp.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, linux-scsi@vger.kernel.org

On Wed, Sep 01, 2004 at 11:20:42AM -0500, AJ Lewis wrote:
> Do we want all these attributes in the scsi_host class, or should we put them
> in the iscsi devices directory?  So in /sys/bus/iscsi-sfnet/devices/iscsi1 -
> it seems to me these attributes are specific to the iscsi target, and don't
> need to be in the scsi_host class.

I think all attributes that are common over software- and hardware based
iscsi implementations should go into a iscsi transport class.  Of course
it's hard to without a hardware driver to work with.  I remember Qlogic
said they wanted to submit their driver some time in the future, maybe
one of their developers is listening on linux-scsi.

