From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 1st  REVIEW : UNH iSCSI for 2.6-test5
Date: Wed, 24 Sep 2003 18:48:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030924184825.A21635@infradead.org>
References: <20030924151228.8206.qmail@web60208.mail.yahoo.com> <20030924183906.A21401@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:52237 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261500AbTIXRs0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 13:48:26 -0400
Content-Disposition: inline
In-Reply-To: <20030924183906.A21401@infradead.org>; from hch@infradead.org on Wed, Sep 24, 2003 at 06:39:06PM +0100
List-Id: linux-scsi@vger.kernel.org
To: jd <jpd_hp_linux_scsi@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Sep 24, 2003 at 06:39:06PM +0100, Christoph Hellwig wrote:
>  - I can't find module_init/init_module.  Where's the entry point
>    of this code?

Sorry, scrap that - I had a truncated patch here.  But you really
want to move away from oldish scsi_module.c using code to the
modern hotplug model.  See e.g. usb-storage or sbp2 for examples.

