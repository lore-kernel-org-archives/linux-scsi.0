From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13311] mptsas: ioc0: removing ssp device, kernel oops
Date: Tue, 9 Jun 2009 21:27:08 GMT
Message-ID: <200906092127.n59LR8i6015475@demeter.kernel.org>
References: <bug-13311-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39077 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZFIV1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 17:27:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n59LR8ON015476
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2009 21:27:08 GMT
In-Reply-To: <bug-13311-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D13311





--- Comment #3 from Mike Loseke <mike.tummy@gmail.com>  2009-06-09 21:2=
7:07 ---
On Thu, May 28, 2009 at 2:00 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> (switched to email. =C2=A0Please respond via emailed reply-to-all, no=
t via the
> bugzilla web interface).
>
> On Thu, 14 May 2009 18:17:10 GMT bugzilla-daemon@bugzilla.kernel.org =
wrote:
>
> > http://bugzilla.kernel.org/show_bug.cgi?id=3D13311
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Summary: mptsas: ioc0: rem=
oving ssp device, kernel oops
>
> I'd have thought that the severity of this problem is not matched by
> the response.
>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Product: SCSI Drivers
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Version: 2.5
> > =C2=A0 =C2=A0 Kernel Version: 2.6.27.21
>
> Is it reproducible? =C2=A0If so, is there any change that it can be r=
etested
> under a 2.6.29-based kernel?

We've put a 2.6.29 kernel on these two systems and experienced another
kernel oops yesterday.  So far, we haven't been able to reproduce it
on demand, but it has occurred under a heavier system load each time
(load average of 16 with 2,000 blocks/sec every 5 seconds writes to
the devices attached using the mptsas driver.

The oops from yesterday isn't identical to the previous oops, but the
end result is the same where the system has to be rebooted.  I've
attached that the log capture of the oops.

The system is identical to the original specs, just the kernel has chan=
ged:

# cat /proc/version
Linux version 2.6.29.4-0.1-default (root@tile01-primary) (gcc version
4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Tue May
26 22:50:58 CDT 2009

Hopefully this is helpful.

Mike

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
