From: Jonathan Isom <jeisom@gmail.com>
Subject: Re: 2.6.39 and Powerfile c200
Date: Mon, 30 May 2011 16:08:45 -0500
Message-ID: <BANLkTin=kaUtYMi7QeEAJmSLvLm7rmADkQ@mail.gmail.com>
References: <BANLkTikkCOML4aNv_wSrk9VRSofjVwtVAw@mail.gmail.com>
 <20110528202646.02280a95@stein> <BANLkTi=JUTZ+7DNNZJR5wpODes78tYPVjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43222 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1E3VJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2011 17:09:07 -0400
Received: by qwk3 with SMTP id 3so1812227qwk.19
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2011 14:09:06 -0700 (PDT)
In-Reply-To: <BANLkTi=JUTZ+7DNNZJR5wpODes78tYPVjA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Sat, May 28, 2011 at 3:32 PM, Jonathan Isom <jeisom@gmail.com> wrote=
:
> On Sat, May 28, 2011 at 1:26 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> (Cc: lsml)
>>
>> On May 27 Jonathan Isom wrote to linux1394-user:
>>> After upgrading to 2.6.39, =A0I'm getting "rejecting I/O to offline
>>> device" repeatedly in dmesg. =A0Full log is attached.
>>> I can load disks into the DVD drives, however the drives a not usab=
le.
>>> =A0The Powerfile C200 is a 200 Disk DVD
>>> Changer with 2 drives. I didn't turn on the Changer till 249508.718=
311.
>>
>> Which is:
>>
>> [249508.718311] firewire_core: phy config: card 0, new root=3Dffc1, =
gap_count=3D5
>> [249509.320382] firewire_core: created device fw1: GUID 003060f20000=
2759, S400
>> [249509.458787] scsi8 : SBP-2 IEEE-1394
>> [249509.659575] firewire_sbp2: fw1.0: logged in to LUN 0000 (0 retri=
es)
>> [249509.661749] scsi 8:0:0:0: CD-ROM =A0 =A0 =A0 =A0 =A0 =A0TOSHIBA =
=A0DVD-ROM SD-M1212 1032 PQ: 0 ANSI: 0 CCS
>> [249509.666218] sr1: scsi3-mmc drive: 32x/32x cd/rw xa/form2 cdda tr=
ay
>> [249509.666479] sr 8:0:0:0: Attached scsi CD-ROM sr1
>> [249509.666611] sr 8:0:0:0: Attached scsi generic sg5 type 5
>> [249509.668791] firewire_sbp2: fw1.0: logged in to LUN 0001 (0 retri=
es)
>> [249509.671056] scsi 8:0:0:1: CD-ROM =A0 =A0 =A0 =A0 =A0 =A0TOSHIBA =
=A0DVD-ROM SD-M1212 1032 PQ: 0 ANSI: 0 CCS
>> [249509.676162] sr2: scsi3-mmc drive: 32x/32x cd/rw xa/form2 cdda tr=
ay
>> [249509.676385] sr 8:0:0:1: Attached scsi CD-ROM sr2
>> [249509.676514] sr 8:0:0:1: Attached scsi generic sg6 type 5
>> [249509.678677] firewire_sbp2: fw1.0: logged in to LUN 0002 (0 retri=
es)
>> [249509.683634] scsi 8:0:0:2: Medium Changer =A0 =A0Escient =A0Power=
file C200 =A0 04A =A0PQ: 0 ANSI: 3
>>
>> OK.
>>
>> [249509.685951] ch0: reading element address assigment page failed!
>>
>> Don't know if this is bad or not.
>>
>> [249509.685962] ch0: INITIALIZE ELEMENT STATUS, may take some time .=
=2E.
>> [249509.686719] ch0: ... finished
>> [249509.686729] ch 8:0:0:2: Attached scsi changer ch0
>> [249509.686948] ch 8:0:0:2: Attached scsi generic sg7 type 8
>>
>> OK.
>>
>> [249539.712075] firewire_sbp2: fw1.0: sbp2_scsi_abort
>> [249549.712062] firewire_sbp2: fw1.0: sbp2_scsi_abort
>> [249549.712287] sr 8:0:0:0: Device offlined - not ready after error =
recovery
>> [249549.712393] sr 8:0:0:0: rejecting I/O to offline device
>> [249583.704061] firewire_sbp2: fw1.0: sbp2_scsi_abort
>> [249593.704070] firewire_sbp2: fw1.0: sbp2_scsi_abort
>> [249593.704307] sr 8:0:0:1: Device offlined - not ready after error =
recovery
>> [249593.704423] sr 8:0:0:1: rejecting I/O to offline device
>> [249593.706254] sr 8:0:0:0: rejecting I/O to offline device
>> [249593.706276] sr 8:0:0:0: rejecting I/O to offline device
>> [249593.706948] sr 8:0:0:0: rejecting I/O to offline device
>> [249593.706976] sr 8:0:0:0: rejecting I/O to offline device
>> [249593.709258] sr 8:0:0:1: rejecting I/O to offline device
>> [...repeated almost 2000 times...]
>> [250542.004258] sr 8:0:0:0: rejecting I/O to offline device
>> [250542.004269] sr 8:0:0:0: rejecting I/O to offline device
>> [250542.004340] sr 8:0:0:1: rejecting I/O to offline device
>> [250542.004350] sr 8:0:0:1: rejecting I/O to offline device
>>
>> All three SCSI units were probed and attached successfully. =A0This =
involves
>> successful execution of a few basic SCSI commands.
>>
>> 30 seconds after that, and again after additional 10 seconds and fur=
ther
>> 34 seconds + additional 10 seconds, firewire-sbp2 logs that in total=
 four
>> SCSI commands timed out. =A0The kernel's SCSI subsystem decides to t=
ake the
>> two DVD-ROM logical units offline.
>>
>> Why the time-outs happened is is not clear. =A0Also, I have no idea =
what
>> could be done with the kernel's SCSI subsystem so that it logs *whic=
h*
>> commands timed out.
>>
>> Was the 2.6.39 kernel update the only change that you did on your sy=
stem,
>> or were there userland updates too? =A0If yes, maybe you have a prog=
ram now
>> that sends weird commands that crash the Powerfile's firmware.
>
> I have done some updates. Been messing around trying to get it
> working. I'm getting
> the same problem with 2.6.38.2. =A0At one point I got a drive to work
> under 2.6.39, but not
> the other drive and the changer failed to show. =A0I got an older
> firewire mac I'll try messing
> with it later to see if there is a failure in the Powerfile.

Hi
   Well I messed around with it on the mac.  It works fine with it.  Co=
uld
this be a firewire board failure or is it more indicative of a software=
 bug?
You mentioned updates to software.  What packages would you suggest
I look besides udev?

Thanks

Jonathan

> Thanks for the input.
>
> Jonathan
>
>
>> --
>> Stefan Richter
>> -=3D=3D=3D=3D=3D-=3D=3D-=3D=3D -=3D-=3D =3D=3D=3D--
>> http://arcgraph.de/sr/
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
