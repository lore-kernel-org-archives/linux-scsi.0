From: Douglas Gilbert <dougg@torque.net>
Subject: Re: no utility / method to show association between host bus	adapter
 and non-sg BLOCK devices
Date: Thu, 11 Jan 2007 15:15:18 -0500
Message-ID: <45A69AD6.60207@torque.net>
References: <8260533.post@talk.nabble.com> <45A53290.1060400@torque.net> <45A62C32.8E7F.00B8.0@novell.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46108 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbXAKUP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 15:15:27 -0500
In-Reply-To: <45A62C32.8E7F.00B8.0@novell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thayne Harmon <THARMON@novell.com>
Cc: linux-scsi@vger.kernel.org

Thayne Harmon wrote:
> Gentlemen,
> 
> hwinfo, lshal, sysfs do not show the relationship for non-sg BLOCK devices with there 
> associated Host Bus Adapter.

All devices (i.e. logical units) have a 4 element tuple
associated with them and the first element is the host
number. A HBA contains one or more hosts. Then you can
datamine in /sys/class/scsi_host/host<n> for whatever
information you want.

> Do you know of a utility or method that can show this?

May I suggest lsscsi. That won't help you in the lk 2.4
series and earlier though There are other methods by
which the sg device corresponding to a "non-sg" block
device (e.g. /dev/sdc) can be found.

> Example is the HP/Compaq CCISS block driver.
> 
> The HBA and devices are listed, but no association is given or can be determine, 
> only by the user knowing which is which.
> 
> The kernel certainly knows, surely the above apps could be made to 
> determine this or some utility exits that will show this?

See http://www.torque.net/scsi/lsscsi.html

Doug Gilbert
