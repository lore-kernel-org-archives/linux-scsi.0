From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Fri, 17 Jul 2009 11:43:25 GMT
Message-ID: <200907171143.n6HBhPBW011180@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58200 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934411AbZGQLn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2009 07:43:26 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6HBhPBk011181
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2009 11:43:25 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D13783





--- Comment #7 from Kay Sievers <kay.sievers@vrfy.org>  2009-07-17 11:4=
3:24 ---
On Thu, Jul 16, 2009 at 19:26, <bugzilla-daemon@bugzilla.kernel.org> wr=
ote:
> http://bugzilla.kernel.org/show_bug.cgi?id=3D13783

> --- Comment #6 from Andreas Fackler <AndreasFackler@web.de> =C2=A0200=
9-07-16 17:26:37 ---
> Yes, if I stop either udevd or hald-addon-storage, no more events are=
 generated
> and cpu usage goes back to normal.

Just to double check:

Killing the hal addon alone makes the event loop stop?

There is a binary: "hal-disable-polling", which can be used to
permanently disable the polling of the device. If you use that and
reboot the box, the issue goes away?

Thanks!

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
