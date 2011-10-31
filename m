From: yoma sophian <sophian.yoma@gmail.com>
Subject: Re: question about passing physical address to lower level driver in scsi
Date: Mon, 31 Oct 2011 20:28:16 +0800
Message-ID: <CADUS3okdN2m+EGacxXzVebUXk+ZnOW7yp8M5BU1bNDR4caoYgQ@mail.gmail.com>
References: <CADUS3okkKEu_Re1FU_AvVk6agFwrmx0mwzbMSmso6pV8HFfWMA@mail.gmail.com>
	<20111030132821.4df33f1e@stein>
	<CADUS3on70KNyS5=NfMRN2eJ_aOGnZbUqo7_P_RsrEuW49xh48A@mail.gmail.com>
	<CAGRGNgWE4JQ15+Q3rpCvHs_EXiGZ0yu_X9_3FfkrBgsOiXvvLQ@mail.gmail.com>
	<20111031132209.1d1ee186@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44277 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab1JaM2R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2011 08:28:17 -0400
Received: by qyk4 with SMTP id 4so3768725qyk.19
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2011 05:28:17 -0700 (PDT)
In-Reply-To: <20111031132209.1d1ee186@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Julian Calaby <julian.calaby@gmail.com>, linux-scsi@vger.kernel.org

hi all:

2011/10/31, Stefan Richter <stefanr@s5r6.in-berlin.de>:
> On Oct 31 Julian Calaby wrote:
>> Hi,
>>
>> On Mon, Oct 31, 2011 at 12:53, yoma sophian <sophian.yoma@gmail.com>
>> wrote:
>> > hi stefan:
>> > Thanks for your reply.
>> > 2011/10/30, Stefan Richter <stefanr@s5r6.in-berlin.de>:
>> >> The low level driver, not SCSI core, is responsible to obtain a DMA
>> >> address.
>> >
>> > Why I ask this because I found there is no same transformation for
>> > scsi usb subsystem.
>> > Would anyone can let me know where it is?
>>
>> I am not familiar with the code in question, but I would guess that
>> this would happen in the USB Controller Interface driver.
>
> I don't know the USB subsystem either.  Anyway, in this case the
> "SCSI low-level" (i.e. SCSI transport and interconnect driver)
> internally consists of USB high-level (storage), USB core, and USB
> low-level (UHCI, EHCI or whatever).  "grep -r dma_map_sg drivers/usb/"
> shows occurrences of scatter-gather list DMA mappings in the USB core.  I
> haven't checked whether these are indeed the ones that the usb-storage
> driver relies on.
I will check where you mentioned.
appreciate your kind help,
