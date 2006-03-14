From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2.6.16-rc6] Promise SuperTrak driver
Date: Tue, 14 Mar 2006 10:40:03 +0100
Message-ID: <1142329204.3027.26.camel@laptopd505.fenrus.org>
References: <NONAMEBgJJ72jYxDwLd000000d3@nonameb.ptu.promise.com>
	 <1142327906.3027.24.camel@laptopd505.fenrus.org>
	 <44168C86.8060107@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49639 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750765AbWCNJkK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 04:40:10 -0500
In-Reply-To: <44168C86.8060107@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ed Lin <ed.lin@promise.com>, Andrew Morton <akpm@osdl.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "promise_linux@promise.com" <promise_linux@promise.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, 2006-03-14 at 04:27 -0500, Jeff Garzik wrote:
> Arjan van de Ven wrote:
> >>>>+struct st_sgitem {
> >>>>+struct st_sgtable {
> >>>>+struct handshake_frame {
> >>>>+struct req_msg {
> >>>>+struct status_msg {
> >>>
> >>>Has this all been tested on big-endian hardware?
> >>>
> >>
> >>No. It was only tested on i386 and x86-64 machines.
> > 
> > 
> > you'll want those to be __attribute__((packed)) as well btw
> 
> I thought that was unnecessary if the struct members are ordered such 
> that compiler would not add padding?

the rules for when padding gets added are different for each platform
though; worst case of adding it is that it serves as documentation that
the layout matters :)


