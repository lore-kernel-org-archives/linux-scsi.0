From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PATCH: fix crashes with aacraid
Date: Mon, 03 Jan 2005 18:43:25 +0000
Message-ID: <1104776060.13297.5.camel@localhost.localdomain>
References: <1104158617.20952.51.camel@localhost.localdomain>
	 <1104771922.21673.4.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:48817 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S261632AbVACTrh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2005 14:47:37 -0500
In-Reply-To: <1104771922.21673.4.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Llu, 2005-01-03 at 17:05, Mark Haverkamp wrote:
> On Mon, 2004-12-27 at 14:43 +0000, Alan Cox wrote:
> > Is this change still needed for 2.6.10  Mark ?
> 
> I thought that the consensus was to remove aac_handle_aif altogether
> like the patch sent in by Tom Coughlan on Dec. 8th.

Thats what I assumed but then I could find nothing in 2.6.10 that made
aacraid work so I wasn't sure what if anything had been applied

