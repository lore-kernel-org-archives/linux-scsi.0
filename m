From: Jonathan Isom <jeisom@gmail.com>
Subject: Re: 2.6.39 and Powerfile c200
Date: Tue, 31 May 2011 11:48:38 -0500
Message-ID: <BANLkTinSPtcr-btv7v5ZUkdPObguYDSSag@mail.gmail.com>
References: <BANLkTikkCOML4aNv_wSrk9VRSofjVwtVAw@mail.gmail.com>
 <20110528202646.02280a95@stein> <BANLkTi=JUTZ+7DNNZJR5wpODes78tYPVjA@mail.gmail.com>
 <BANLkTin=kaUtYMi7QeEAJmSLvLm7rmADkQ@mail.gmail.com> <20110530232429.3ef05054@stein>
 <BANLkTin4A-RCNtogW6LiVpumNcea+rmCAg@mail.gmail.com> <20110530233841.4e652322@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52052 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab1EaQs7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 12:48:59 -0400
Received: by qwk3 with SMTP id 3so2180256qwk.19
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2011 09:48:58 -0700 (PDT)
In-Reply-To: <20110530233841.4e652322@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Mon, May 30, 2011 at 4:38 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On May 30 Jonathan Isom wrote:
>> 02:00.0 FireWire (IEEE 1394) [0c00]: Agere Systems FW643 PCI
>> Express1394b Controller (PHY/Link) [11c1:5901] (rev 06)
>
> Ah right; you were the one who reported that FW643 rev 06 issue again=
st
> kernel 2.6.36 which we fixed in 2.6.37. =A0Another dead end idea.

Well I did some further testing.  If I boot with /bin/sh as init and
manually load the firewire
modules the C200 works.  I moved out all kernel modules but firewire
and loaded init and
it start giving the offline messages.  So it appears to be a userspace
problem.  Just  not
sure where to start. I already did some digging in udev but no luck so
far. I'm running gentoo
which probably make tracking it down just a little harder as there are
few identical installs in the
world.  Below is a listing of init scripts loaded at boot.

Any Ideas?

Jonathan


> --
> Stefan Richter
> -=3D=3D=3D=3D=3D-=3D=3D-=3D=3D -=3D-=3D =3D=3D=3D=3D-
> http://arcgraph.de/sr/
>
 init scripts
  apache2                   default
  atd                       default
  avahi-daemon              default
  avahi-dnsconfd            default
  bluetooth                 default
  bootmisc                  boot
  callerid                  default
  cgroups                   boot
  consolefont               boot
    cpufrequtils              default
  cupsd                     default
  dbus                      default
  devfs                     sysinit
  device-mapper             boot
  dmesg                     sysinit
  fsck                      boot
  hdparm                    default
  hostname                  boot
  hwclock                   boot
  irexec                    default
  keymaps                   boot
  killprocs                 shutdown
  lircd                     default
  local                     default
  localmount                boot
  modules                   boot
  mount-ro                  shutdown
  mpd                       default
  mtab                      boot
  mysql                     default
  mythbackend               default
  net.eth2
  net.lo                    boot
  netmount                  default
  network
  nfs                       default
  ntp-client                default
  ntpd                      default
  procfs                    boot
  qpsmtpd                   default
  root                      boot
  samba                     default
  savecache                 shutdown
  smartd                    default
  sshd                      default
  swap                      boot
  sysctl                    boot
  syslog-ng                 default
  termencoding              boot
  udev                      sysinit
  udev-postmount            default
  urandom                   boot
  vixie-cron                default
  xdm                       default
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
