From: "K.R. Foley" <kr@cybsft.com>
Subject: Re: [PATCH] fix command retries in spi_transport class
Date: Mon, 02 May 2005 09:20:30 -0500
Message-ID: <4276372E.7020706@cybsft.com>
References: <1114991896.4788.44.camel@mulgrave>	 <4276353D.7080204@cybsft.com> <1115043492.5006.0.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail3.utc.com ([192.249.46.192]:21230 "EHLO mail3.utc.com")
	by vger.kernel.org with ESMTP id S261270AbVEBOUj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2005 10:20:39 -0400
In-Reply-To: <1115043492.5006.0.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Mon, 2005-05-02 at 09:12 -0500, K.R. Foley wrote:
> 
>> [<c0266489>] ahc_set_width+0x109/0x1a0
>> [<c026e661>] ahc_reset_channel+0x301/0x530
>> [<c02646b0>] ahc_handle_scsiint+0x180/0xf80
>> [<c0278208>] ahc_linux_isr+0x218/0x2e0
>> [<c013c80e>] handle_IRQ_event+0x3e/0x90
>> [<c013c937>] __do_IRQ+0xd7/0x160
>> [<c0105666>] do_IRQ+0x26/0x40
>> [<c0103946>] common_interrupt+0x1a/0x20
>> [<c0100c8e>] cpu_idle+0x4e/0x90
>> [<00000000>] 0x0
>> [<dff03fbc>] 0xdff03fbc
> 
> 
> Actually, you need to reverse the bogus patch to aic7xxx_core.c as
> well ...  that's what's causing the oops.
> 
> James
> 
> 
> 
Arggg :-) I will try that and report back.

-- 
    kr
