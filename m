From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: need help to merge (small) virtual scsi driver upstream.
Date: Mon, 19 Jan 2009 20:29:26 +0100
Message-ID: <e2e108260901191129l482b4b04j550ce9b2363786e@mail.gmail.com>
References: <4974CED2.9000900@hw0.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:22050 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbZAST32 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2009 14:29:28 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1379769fgg.17
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2009 11:29:26 -0800 (PST)
In-Reply-To: <4974CED2.9000900@hw0.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Henrik Stokseth <henrik@hw0.org>
Cc: Linux SCSI ML <linux-scsi@vger.kernel.org>

On Mon, Jan 19, 2009 at 8:04 PM, Henrik Stokseth <henrik@hw0.org> wrote:
> Hi! I'm one of the developers on the CDEmu project.
>
> We want to get a driver merged into vanilla linux kernel. CDEmu is a
> software suite that allows people to take a CD/DVD-image and mount it on
> the system in the form of a virtual disc. Major parts of this software
> is based on user-space components, but we have a kernel module that's
> responsible for acting like a SCSI HBA. Mainly all
> this HBA does is to send requests to a userspace daemon for processing
> and then fetch the result and send it back to the SCSI subsystem.
>
> The project's homepage is here: http://cdemu.sourceforge.net
>
> I went over the code to make sure it follows the coding style that's
> used. Is there anything else I need to do? I'm a programmer but
> kernel code is something that I seldom touch.

Does your software emulate a SCSI CD drive ? If so, are you familiar
with the support for userspace SCSI targets in STGT and/or SCST ?

Bart.
