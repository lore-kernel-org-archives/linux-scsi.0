From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: 03 Dec 2003 09:09:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070464184.1771.33.camel@mulgrave>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
	<03120217260300.01630@naveenb-lnx.cisco.com>
	<1070383028.2345.8.camel@mulgrave>
	<03120319364802.02505@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:47622 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264581AbTLCPLK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 10:11:10 -0500
In-Reply-To: <03120319364802.02505@naveenb-lnx.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: naveenb@cisco.com
Cc: Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Wed, 2003-12-03 at 08:06, Naveen Burmi wrote:
> PREVENT_DATA_CORRUPTION was based on our assumption which is not correct and 
> Linux SCSI subsystem is architected for zero copy, therefore we are removing 
> PREVENT_DATA_CORRUPTION.

Just as a matter of interest, *all* unix like operating systems have
used a zero copy architecture (well, in SCSI; networking came a bit
later) for at least the last decade, so you might want to check this
assumption in other ports of your iscsi initiator.

James


