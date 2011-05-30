From: Jonathan Isom <jeisom@gmail.com>
Subject: Re: 2.6.39 and Powerfile c200
Date: Mon, 30 May 2011 16:26:50 -0500
Message-ID: <BANLkTin4A-RCNtogW6LiVpumNcea+rmCAg@mail.gmail.com>
References: <BANLkTikkCOML4aNv_wSrk9VRSofjVwtVAw@mail.gmail.com>
 <20110528202646.02280a95@stein> <BANLkTi=JUTZ+7DNNZJR5wpODes78tYPVjA@mail.gmail.com>
 <BANLkTin=kaUtYMi7QeEAJmSLvLm7rmADkQ@mail.gmail.com> <20110530232429.3ef05054@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51769 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1E3V1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2011 17:27:11 -0400
Received: by qwk3 with SMTP id 3so1816505qwk.19
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2011 14:27:10 -0700 (PDT)
In-Reply-To: <20110530232429.3ef05054@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Mon, May 30, 2011 at 4:24 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On May 30 Jonathan Isom wrote:
>> > On Sat, May 28, 2011 at 1:26 PM, Stefan Richter
>> >> Was the 2.6.39 kernel update the only change that you did on your=
 system,
>> >> or were there userland updates too? =A0If yes, maybe you have a p=
rogram now
>> >> that sends weird commands that crash the Powerfile's firmware.
> [...]
>>
>> =A0 =A0Well I messed around with it on the mac. =A0It works fine wit=
h it. =A0Could
>> this be a firewire board failure or is it more indicative of a softw=
are bug?
>
> FireWire board failures usually cause some more pronounced I/O errors=
 than
> mere SCSI request time-outs; so while it is a possible cause, it is a
> rather unlikely one.
>
>> You mentioned updates to software. =A0What packages would you sugges=
t
>> I look besides udev?
>
> If there is hal(d) on your system, shut this service down and retry.
No hald.

> Another thought: =A0Which FireWire controller do you have according t=
o
> lspci -nn?


02:00.0 FireWire (IEEE 1394) [0c00]: Agere Systems FW643 PCI
Express1394b Controller (PHY/Link) [11c1:5901] (rev 06)


> --
> Stefan Richter
> -=3D=3D=3D=3D=3D-=3D=3D-=3D=3D -=3D-=3D =3D=3D=3D=3D-
> http://arcgraph.de/sr/
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
