From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43359] LVM volumes not detected
Date: Thu, 14 Jun 2012 04:32:27 +0000 (UTC)
Message-ID: <20120614043227.8EC4A12060F@bugzilla.kernel.org>
References: <bug-43359-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58655 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab2FNEcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2012 00:32:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CBCDF204BE
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2012 04:32:29 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id D975B204BA
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2012 04:32:28 +0000 (UTC)
In-Reply-To: <bug-43359-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D43359


=46ran=C3=A7ois Valenduc <francois.valenduc@tvcablenet.be> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
             Status|NEW                         |RESOLVED
         Resolution|                            |UNREPRODUCIBLE




--- Comment #3 from Fran=C3=A7ois Valenduc <francois.valenduc@tvcablene=
t.be>  2012-06-14 04:32:27 ---
I don't understand at all what has happened but the problem is gone. I
recompiled my kernel without using ccache and it works correctly. I use=
 ccache
since a very long time and it's the first time I encounter such a probl=
em.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
