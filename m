From: Gwendal Grignou <gwendal@google.com>
Subject: Re: [PATCH] Allow ATA_ passthrough command through sg.
Date: Mon, 29 Jun 2009 16:39:03 -0700
Message-ID: <e7510f760906291639p1a7bb104n43470817fdb9593b@mail.gmail.com>
References: <1246310665-31727-1-git-send-email-gwendal@google.com>
	 <20090629232045.14a426b6@lxorguk.ukuu.org.uk>
	 <4A494DB4.2060908@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:9548 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZF2XjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 19:39:05 -0400
In-Reply-To: <4A494DB4.2060908@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Sorry for the noise: I thought I needed that change to send ATA
passthrough commands as root. The change is indeed useless and
dangerous.

Gwendal.

On Mon, Jun 29, 2009 at 4:26 PM, Jeff Garzik<jeff@garzik.org> wrote:
> Alan Cox wrote:
>>
>> On Mon, 29 Jun 2009 14:24:25 -0700
>> Gwendal Grignou <gwendal@google.com> wrote:
>>
>>> We can already send ATA specific commands using /dev/sd device file=
s.
>>> This patch allow to use /dev/sg device files as well.
>>
>> That seems a very very bad idea. The point of the filters is only to
>> allow through commands that are safe for all users with read or writ=
e
>> permission to use.
>>
>> Backdooring it with arbitary passthrough ATA12/ATA16 commands doesn'=
t
>> seem very wise.
>
> Indeed. =A0This pretty much defeats the filter for all ATA commands, =
including
> ones that can brick your drive.
>
> =A0 =A0 =A0 =A0Jeff
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
