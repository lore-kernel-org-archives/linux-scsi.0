From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: AIC7902 lockups
Date: Mon, 11 Aug 2003 11:27:50 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2429712704.1060622870@aslan.btc.adaptec.com>
References: <20030811143610.A19365@laokoon.bug.net>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:45247 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S272894AbTHKR0H
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 13:26:07 -0400
In-Reply-To: <20030811143610.A19365@laokoon.bug.net>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>, linux-scsi@vger.kernel.org

> Hi,
> 
> sorry for asking again, but my problem with two disks connected
> to an Adaptec AIC7902 still exists. Any help to solve the
> annoying problem or hints are greatly appreciated.

The messages are not complete... the top is clipped.  Were you
using a serial console to capture this log?

Can you compile your kernel with register pretty printing enabled
in the driver?  It is a config time menu option.  This greatly
simplifies understanding the logs.

Can you also provide the output of "lspci -vv -n" from the
system as well as the output from "dmesg" right after boot.

--
Justin

