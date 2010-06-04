From: Dan Christensen <jdc@uwo.ca>
Subject: Re: Question / Request about timeouts of SATA harddisks
Date: Fri, 04 Jun 2010 12:06:36 -0400
Message-ID: <87vd9ylr3n.fsf@uwo.ca>
References: <4C074C8D.509@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54739 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab0FDQKG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jun 2010 12:10:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1OKZT9-0007B8-UB
	for linux-scsi@vger.kernel.org; Fri, 04 Jun 2010 18:10:03 +0200
Received: from bas3-london14-1096780455.dsl.bell.ca ([65.95.138.167])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 04 Jun 2010 18:10:03 +0200
Received: from jdc by bas3-london14-1096780455.dsl.bell.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 04 Jun 2010 18:10:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

"Stefan /*St0fF*/ H=C3=BCbner" <stefan.huebner@stud.tu-ilmenau.de> writ=
es:

> concerning RAIDs with Desktop class drives it'd be good to know if th=
ere
> is any kernel-timeout-value which states, how long a diskdrive may ta=
ke
> to process a command.  If it doesn't respond in-time I've seen in my
> logs and with many disks that the sg-eh becomes active resetting the
> bus.  So somewhere there needs to be such a timeout.
>
> The question is: can this timeout-value be found somewhere in the sys=
fs?
>  If "yes" where?  If "no", can it be exported?

I'd like to second this request, as I have two drives in a raid 5 array
that occasionally (once every month or two) suffer from a timeout, whic=
h
causes them to be kicked from the raid array.  SMART tests show no
problems, so it would be convenient if I could increase the timeouts.

(More details about my set-up are in this thread on the linux-raid list=
:

  http://marc.info/?l=3Dlinux-raid&m=3D127548808104494&w=3D2
)

Dan

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
