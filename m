From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: question about passing physical address to lower level driver in scsi
Date: Mon, 31 Oct 2011 17:11:58 +1100
Message-ID: <CAGRGNgWE4JQ15+Q3rpCvHs_EXiGZ0yu_X9_3FfkrBgsOiXvvLQ@mail.gmail.com>
References: <CADUS3okkKEu_Re1FU_AvVk6agFwrmx0mwzbMSmso6pV8HFfWMA@mail.gmail.com>
 <20111030132821.4df33f1e@stein> <CADUS3on70KNyS5=NfMRN2eJ_aOGnZbUqo7_P_RsrEuW49xh48A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32809 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1JaGMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2011 02:12:19 -0400
Received: by iaby12 with SMTP id y12so6829287iab.19
        for <linux-scsi@vger.kernel.org>; Sun, 30 Oct 2011 23:12:19 -0700 (PDT)
In-Reply-To: <CADUS3on70KNyS5=NfMRN2eJ_aOGnZbUqo7_P_RsrEuW49xh48A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yoma sophian <sophian.yoma@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

Hi,

On Mon, Oct 31, 2011 at 12:53, yoma sophian <sophian.yoma@gmail.com> wrote:
> hi stefan:
> Thanks for your reply.
> 2011/10/30, Stefan Richter <stefanr@s5r6.in-berlin.de>:
>> On Oct 30 yoma sophian wrote:
>>> in scsi_init_sgtable, we create sgtable, sdb->table.sgl, and get the
>>> page from blk_rq_map_sg.
>>> But when the dma_address of sdb->table.sgl will be calclated out
>>> before send the scsi command down to the lower level driver?
>>
>> The low level driver, not SCSI core, is responsible to obtain a DMA
>> address.
>
> Why I ask this because I found there is no same transformation for
> scsi usb subsystem.
> Would anyone can let me know where it is?

I am not familiar with the code in question, but I would guess that
this would happen in the USB Controller Interface driver.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
