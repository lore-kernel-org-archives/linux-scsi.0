From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] g_NCR5380: Remove deprecated __setup
Date: Sun, 25 Sep 2016 16:45:58 -0700
Message-ID: <20160925234558.GA7312@infradead.org>
References: <1474743545-4731-1-git-send-email-linux@rainbow-software.org>
 <1474743545-4731-2-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53544 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757597AbcIYXqC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2016 19:46:02 -0400
Content-Disposition: inline
In-Reply-To: <1474743545-4731-2-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Sep 24, 2016 at 08:59:03PM +0200, Ondrej Zary wrote:
> Remove deprecated __setup for parsing command line parameters.
> g_NCR5380.* parameters could be used instead.

This assumes everyone has moved over to it.  But I suspect the remaining
hand full of users could adjust..
