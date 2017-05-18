From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH blktests 0/3] Add SCSI generic test group
Date: Thu, 18 May 2017 06:19:28 -0700
Message-ID: <20170518131928.GA26060@infradead.org>
References: <cover.1495109149.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35092 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934387AbdERNT3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2017 09:19:29 -0400
Content-Disposition: inline
In-Reply-To: <cover.1495109149.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Omar Sandoval <osandov@osandov.com>, Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

All SG_IO test should also apply to block device nodes that support
the ioctl..
