From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add SPI-5 constants to scsi.h
Date: Tue, 21 Sep 2004 13:04:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921130438.A22311@infradead.org>
References: <20040921115059.GU642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:24591 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267595AbUIUMEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 08:04:40 -0400
Content-Disposition: inline
In-Reply-To: <20040921115059.GU642@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Tue, Sep 21, 2004 at 12:50:59PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 21, 2004 at 12:50:59PM +0100, Matthew Wilcox wrote:
> 
> Add the new constant names from SPI-5 to <scsi/scsi.h>

<nitpick>
What about having a section ala

/*
 * Old SCSI2 names, don't use in new code
 */
#define ABORT               ABORT_TASK_SET
#define BUS_DEVICE_RESET    TARGET_RESET

instead of intermixing them with the rest of the defines?

</nitpick>
