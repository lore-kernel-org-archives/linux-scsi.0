From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Boot order of LSI MPT Fusion devices controllable?
Date: Tue, 30 Nov 2004 12:48:48 -0800
Message-ID: <20041130204848.GC8863@us.ibm.com>
References: <200412010331.VAA21676@catalyst.austin.ibm.com> <1101843791.1779.1048.camel@rebel.corp.whenu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:36844 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262326AbUK3Us4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 15:48:56 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iAUKmoDr622972
	for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2004 15:48:50 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iAUKmnU5416884
	for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2004 13:48:49 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iAUKmnBN030597
	for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2004 13:48:49 -0700
Content-Disposition: inline
In-Reply-To: <1101843791.1779.1048.camel@rebel.corp.whenu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Richard F. Rebel" <rrebel@whenu.com>
Cc: kwhite@austin.ibm.com, linux-scsi@vger.kernel.org

Richard F. Rebel [rrebel@whenu.com] wrote:
> Earlier someone responded to the tune that I needed to change the PCI
> boot order, and unless the bios allows me to change that,  I have to
> move the cards around in the chassis.  I have a cage monkey trying that
> now.
> 

Relying on pci / device probe order will always leave you open to possible
name slippage issues in the future. You mentioned that you are running mdk
so you may want to look at using udev for your device naming.



-andmike
--
Michael Anderson
andmike@us.ibm.com

