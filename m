From: =?UTF-8?B?6LCi57qy?= <xiegang112@gmail.com>
Subject: Re: The return of the sense data
Date: Wed, 15 Jul 2009 14:33:47 +0800
Message-ID: <d364733c0907142333v1f5a18a7ycf551607699e684b@mail.gmail.com>
References: <d364733c0907142301s29ec243eu34508aaf3ddad0a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f185.google.com ([209.85.216.185]:58834 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZGOGds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2009 02:33:48 -0400
Received: by pxi15 with SMTP id 15so1470271pxi.33
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2009 23:33:47 -0700 (PDT)
In-Reply-To: <d364733c0907142301s29ec243eu34508aaf3ddad0a2@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, Jul 15, 2009 at 2:01 PM, =E8=B0=A2=E7=BA=B2<xiegang112@gmail.co=
m> wrote:
> Hi,
>
> I'm little confused about the time of returning the sense data.
>
> After the status of the scsi response is check condition and sense
> data is generated, When do we send the sense data? In the response
> which contain the command status of check condition, =C2=A0or send it=
 when
> received a REQUEST SENSE cmd?

I got it=EF=BC=9A
iSCSI targets MUST support and enable autosense.  If Status is CHECK
   CONDITION (0x02), then the Data Segment MUST contain sense data for
   the failed command.

I think there is a little difference between direct access device and
device with scsi transport layer.
=46or example, the driver of LSILOGIC 53C8XX will send request sense
command to do auto sense itself. But for iscsi, it seems that the
request sense command is not needed when auto sense.

Thanks,

> --
> Xie Gang
>



--=20
Xie Gang
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
