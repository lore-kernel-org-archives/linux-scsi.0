From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: generating a Linux WWN?
Date: Tue, 2 Oct 2007 20:45:50 -0700 (PDT)
Message-ID: <460931.21951.qm@web31810.mail.mud.yahoo.com>
References: <4702E3B7.9060403@garzik.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:35782 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751299AbXJCDpv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 23:45:51 -0400
In-Reply-To: <4702E3B7.9060403@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

--- Jeff Garzik <jeff@garzik.org> wrote:
> Luben Tuikov wrote:
> > This still does not justify "let's generate it in the kernel".
> 
> Once an admin specifies to use an alternate WWN provision, the method 
> used to obtain that WWN is an implementation detail and irrelevant.

But you're arguing that the kernel should generate it to "help out"
SAS drivers with HW that has had it's MS/NVRAM erased or corrupted.

The kernel has no business generating SAS WWN.

   Luben

