From: Christoph Hellwig <hch@infradead.org>
Subject: Re: glibc and make headers_install_all provide /usr/include/scsi
Date: Mon, 6 Aug 2007 13:52:12 +0100
Message-ID: <20070806125212.GB12896@infradead.org>
References: <20070806124546.GA2117@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48913 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbXHFMwN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Aug 2007 08:52:13 -0400
Content-Disposition: inline
In-Reply-To: <20070806124546.GA2117@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sources.redhat.com

On Mon, Aug 06, 2007 at 02:45:46PM +0200, Olaf Hering wrote:
> 
> glibc and make headers_install_all provide /usr/include/scsi
> One of them has to go.
> 
> A quick diff shows no differences, expect:

..

> Which copy should be provided by a distributor?

The glibc one of course.  The kernel scsi.h should never have been
added to the list of exportable headers.  

