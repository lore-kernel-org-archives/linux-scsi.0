From: Subs <sar.subs@gmail.com>
Subject: Re: Alternate ways to do Scatter-Gather from BOT Class driver
Date: Tue, 29 Jun 2010 20:30:42 +0530
Message-ID: <AANLkTilIM-9svLKrqaPfsjESn_9VnqsffBDwtiau8B_3@mail.gmail.com>
References: <AANLkTiljLLGh8zbx1EY53-6LezDZ-utWW8FFbpFQwPIr@mail.gmail.com>
	<Pine.LNX.4.44L0.1006281452480.1977-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55999 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab0F2PAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jun 2010 11:00:42 -0400
In-Reply-To: <Pine.LNX.4.44L0.1006281452480.1977-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jun 29, 2010 at 12:25 AM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Mon, 28 Jun 2010, Subs wrote:
>
>> Hi All,
>>
>> In my class driver I am receiving data transfer buffer as number of
>> Scatter-Gather lists from SCSI layer to perform data transfers.
>>
>> Is there any alternate way to get the transfer buffer from SCSI othe=
r
>> than SG. I wanted to receive the complete data transfer buffer as a
>> single pointer.
>
> As far as I know, there is no alternate way to get the transfer buffe=
r
> from the SCSI layer.
>
> However you can get the effect you want by setting the sg_tablesize
> field in your scsi_host_template to 1.
>
> Just out of curiosity, why are you writing a class driver for the BOT
> class? =A0Aren't the two existing drivers in the kernel good enough?
>
> Alan Stern
>
>

By changing sg_tablesize to 1, there is no change in number of buffers
that I am receiving in SG list.


> Just out of curiosity, why are you writing a class driver for the BOT
> class?  Aren't the two existing drivers in the kernel good enough?

I am writing my custom class driver, which can do Control and Bulk
transfers only. This is nowhere related to Mass Storage BOT transfers.

Regards,
Subs
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
