From: Douglas Gilbert <dougg@torque.net>
Subject: Re: IO transfer limits
Date: Wed, 10 Jan 2007 13:38:08 -0500
Message-ID: <45A53290.1060400@torque.net>
References: <8260533.post@talk.nabble.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43365 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964994AbXAJSiY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2007 13:38:24 -0500
In-Reply-To: <8260533.post@talk.nabble.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: john clyne <clyne@ucar.edu>
Cc: linux-scsi@vger.kernel.org

john clyne wrote:
> Can anyone give me some guidance on where in the IO stack I might be running
> into a 512KB limit on IO transfer sizes to an external FC device? I've
> checked IO scheduler parameter
> (/sys/block/<dev>/queue/{max_sectors_kb,max_hw_sectors_kb}. Both are set to
> 32767. I'm using Qlogic HBAs (qla2312), but I don't see any relevent
> parameters. I'm running RHEL 4.0 with a 2.6.9-34 kernel. Any pointers would
> be greatly appreciated.

John,
I discuss the subject in this page:
   http://www.torque.net/sg/sg_io.html
in the section titled:
Maximum transfer size per command

Mike C. has given you the answer for the block device
interface (e.g. via /dev/sda); you should be able
to do about 8 times better via the scsi generic
interface (e.g. /dev/sg0).

Doug Gilbert


