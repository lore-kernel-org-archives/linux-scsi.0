From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Address or Write Phase Parity Error in  Adaptec Ultra320(29320)
Date: Sun, 13 Apr 2003 20:37:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2555792704.1050287878@aslan.scsiguy.com>
References: <005901c30229$735b8c00$8601a8c0@teamglac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.scsiguy.com ([63.229.232.106]:45842 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S262713AbTDNC0U (for <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2003 22:26:20 -0400
In-Reply-To: <005901c30229$735b8c00$8601a8c0@teamglac.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "Michael P. Carel" <mikecarel@teamglac.com>, linux-scsi@vger.kernel.org

> Hi,
> 
> I'm having problem with  my Adaptec Ultra320(29320) in RedHat Linux 7.3
> with kernel 2.4.18-3 a Address or Write Phase Parity Error always display on
> screen and if the system is idle for a long time, the server network
> crushes. I've already used the driver revision 1.3.6 from the freeBSD
> website.
> 
> Can anyone help me please...

Can you send me a full dmesg of your system and the output from "lspci -vv"?
Someone is "talking trash" on the PCI bus.  This is a very frequent problem
with certain motherboards using VIA chipsets.

--
Justin

