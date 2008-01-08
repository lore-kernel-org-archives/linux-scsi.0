From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Common header file for FC definitions
Date: Tue, 8 Jan 2008 13:14:03 +0000
Message-ID: <20080108131403.GA9643@infradead.org>
References: <20080108080924.GA6993@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38180 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbYAHNOH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 08:14:07 -0500
Content-Disposition: inline
In-Reply-To: <20080108080924.GA6993@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, robert.w.love@intel.com

On Tue, Jan 08, 2008 at 09:09:36AM +0100, Christof Schmitt wrote:
> zfcp has a couple of definitions to describe the FC protocol. Grepping
> through the complete source tree shows that e.g. the lpfc module makes
> similar private definitions. It think that it would make sense to
> introduce a global header file for FC related definitions that each FC
> driver can use.
> 
> The attached patch contains some definitons that i found in zfcp and
> could be reused by other drivers.
> 
> What do others think? Would this be useful?

This is a very good idea.  It might make more sense to have the more or
less complete defintions for the fc protocol in the header.  Robert &
folks have been working on a software fc stack part as the fcoe header
so they might have one to contribute.
