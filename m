From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 26 Nov 2003 13:45:01 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031126134501.B6004@infradead.org>
References: <20031027153932.A16679@infradead.org> <00c901c3b251$91016a30$a0074d0a@apac.cisco.com> <20031124074830.C29095@infradead.org> <20031124124543.A1017@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:41478 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263852AbTKZNpF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2003 08:45:05 -0500
Content-Disposition: inline
In-Reply-To: <20031124124543.A1017@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Nov 24, 2003 at 12:45:43PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Surekha.PC" <surekhap@cisco.com>, linux-scsi@vger.kernel.org

On Mon, Nov 24, 2003 at 12:45:43PM -0800, Patrick Mansfield wrote:
> We need a new timeout + canceller mechanism, so that a single command can
> be cancelled without waiting for all other IO on an adapter to complete.
> Errors must still escalate some how so device, bus, or adapter resets can
> (under some conditions) still be issued.
> 
> The qla2xxx hacks around this by adding its own timer that is shorter than
> the scsi cmd timeout. Is that a good or a bad hack? I don't know.

Well, it's a hack :)  Although one that works.   I agree with your above
statement that we need to add support for that to the midlayer.  

