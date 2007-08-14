From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] mpt fusion: Add support for ATTO 4LD: Rebranded LSI 53C1030
Date: Tue, 14 Aug 2007 23:43:54 +0100
Message-ID: <20070814224354.GA17634@infradead.org>
References: <20070814103330.GA9944@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57104 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbXHNWn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 18:43:57 -0400
Content-Disposition: inline
In-Reply-To: <20070814103330.GA9944@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Tue, Aug 14, 2007 at 04:03:31PM +0530, Prakash, Sathya wrote:
> 2. The spi_port_page_2 is in different format than that of LSI generic 
> spi_port_page_2 and hence mapping code is added.

Not that we can change it anymore, but what idiot decided to do such
a change?  An chance LSI could stop licencees from doing such bloody
braindamaged things to the firmware in the future?

add a reminder for anyone to never but ATTO hardware as the company
is utterly useles..
