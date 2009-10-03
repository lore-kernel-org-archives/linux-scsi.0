From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14118] USB storage: "No sense [current]" when connecting
Date: Sat, 3 Oct 2009 20:19:39 GMT
Message-ID: <200910032019.n93KJdOg016115@demeter.kernel.org>
References: <bug-14118-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41274 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZJCUUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Oct 2009 16:20:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n93KJdpw016116
	for <linux-scsi@vger.kernel.org>; Sat, 3 Oct 2009 20:19:39 GMT
In-Reply-To: <bug-14118-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D14118





--- Comment #10 from Mantas Mikul=C4=97nas <grawity@gmail.com>  2009-10=
-03 20:19:36 ---
> Try this patch.  It should fix the problem of the unending retries.  =
There will
> still be errors, but each one will be retried only a small number of =
times.

The patch seems to fix the problems.

(Tried with 2.6.31.1 kernel, default Arch Linux configuration, if that
matters.)

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
