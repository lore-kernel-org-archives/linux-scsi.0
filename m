From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Boot order of LSI MPT Fusion devices controllable?
Date: Tue, 30 Nov 2004 19:40:51 +0000
Message-ID: <20041130194051.GA28062@infradead.org>
References: <1101835224.1779.1040.camel@rebel.corp.whenu.com> <200412010331.VAA21676@catalyst.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:38881 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262281AbUK3TlA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 14:41:00 -0500
Content-Disposition: inline
In-Reply-To: <200412010331.VAA21676@catalyst.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kwhite@austin.ibm.com
Cc: "Richard F. Rebel" <rrebel@whenu.com>, linux-scsi@vger.kernel.org

On Tue, Nov 30, 2004 at 09:31:38PM -0600, kwhite@austin.ibm.com wrote:
> You need to force the LSI U320 scsi driver to load before the fibre-channel
> driver loads.

It's a single driver.
