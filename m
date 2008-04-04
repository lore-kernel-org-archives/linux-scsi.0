From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: mptsas and ioc0: ERRORs
Date: Fri, 4 Apr 2008 09:14:30 +0200
Message-ID: <20080404091430.66daa159.taeuber@bbaw.de>
References: <20080331150434.a3fb336b.taeuber@bbaw.de>
	<20080403123107.71d82746.taeuber@bbaw.de>
	<1207231308.3048.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:37090 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758355AbYDDHUw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2008 03:20:52 -0400
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id 6962C4A8078
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2008 09:20:50 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 5935A937CC
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2008 09:20:49 +0200 (CEST)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id AF207937C1
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2008 09:20:41 +0200 (CEST)
In-Reply-To: <1207231308.3048.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi James,

James Bottomley <James.Bottomley@HansenPartnership.com> schrieb:
> Actually, LSI support might be better.  This:
> 
> > Mar 28 21:45:37 monosan kernel: mptscsih: ioc0: attempting task abort! (sc=ffff8100395bd1c0)
> > Mar 28 21:45:48 monosan kernel: mptbase: Initiating ioc0 recovery
> > Mar 28 21:45:48 monosan kernel: mptbase: ioc0: WARNING - IOC is in FAULT state!!!
> > Mar 28 21:45:51 monosan kernel: mptbase: ioc0: Recovered from IOC FAULT
> 
> Indicates some type of firmware problem on the card (ioc fault means
> fault in the firmware engine).

thank you for this descriptive info. 
 
> This:
> 
> > Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - Received a mf that was already freed
> > Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - req_idx=8380 req_idx_MR=8380 mf=ffff81007db02900 mr=0000000000000000 sc=0000000000000000
> 
> Indicates a rendezvous failure between the ioc firmware and the driver.
> The firmware is sending a response to a task that the driver thinks it
> previously sent.

Ah, ok. It's really good to understand the errors a bit better. 

> The problem for us is that while the driver is open source, it's really
> just a translator for the on board firmware engine.  If the firmware
> engine is truly the cause of these faults, there's not much anyone
> except LSI can do to help.

Do you think it helps to ask LSI directly?

> James

Best regards.
Lars
