From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Linux limitation of amount of SCSI buses
Date: Tue, 29 Jul 2003 08:58:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030729155841.GE8407@beaverton.ibm.com>
References: <3F266F60.5070501@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:51401 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S271704AbTG2PzW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 11:55:22 -0400
Content-Disposition: inline
In-Reply-To: <3F266F60.5070501@il.marvell.com>
List-Id: linux-scsi@vger.kernel.org
To: Rabeeh Khoury <rabeeh@il.marvell.com>
Cc: linux-scsi@vger.kernel.org

Rabeeh Khoury [rabeeh@il.marvell.com] wrote:
> Hi All,
> 
> I'm connecting few cards with 24 buses and Linux gives me only 15 buses.
> Is there any limitation in Linux SCSI subsystem within kernel 2.4.x of 
> the number of SCSI buses ?
> Each bus has a single target and a single LUN.

Does each card have multiple channels (i.e., 24)? If so you may need to
set max_channel to a higher value.

If each card has a single bus there may be a instance limit that the
driver you are using will support.

What driver are you using?

-andmike
--
Michael Anderson
andmike@us.ibm.com

