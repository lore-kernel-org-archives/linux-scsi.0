From: Mark Lord <lsml@rtr.ca>
Subject: Re: Core scsi layer crashes in 2.6.8.1
Date: Tue, 05 Oct 2004 11:57:40 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <4162C474.8010505@rtr.ca>
References: <1096401785.13936.5.camel@localhost.localdomain>	<4162B345.9000806@rtr.ca> <1096988167.2064.7.camel@mulgrave> 	<200410051749.22245.oliver@neukum.org> <1096991666.2064.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S269312AbUJEQaL@vger.kernel.org>
In-Reply-To: <1096991666.2064.25.camel@mulgrave>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Oliver Neukum <oliver@neukum.org>, Anton Blanchard <anton@samba.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
>
> It would add quite a bit of complexity to the reference counted
> aynchronous model to try and force synchronicity between queuecommand
> and scsi_remove_host in the mid-layer.  Therefore it's much easier to
> let the LLD decide what to do with the command.

Presumably the same is also true for scsi_remove_device() ?

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
