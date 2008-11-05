From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Wed,  5 Nov 2008 02:48:19 -0800 (PST)
Message-ID: <20081105104819.51592108057@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754969AbYKEKtV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2008 05:49:21 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA5AmJBs032618
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 02:48:20 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D11898





------- Comment #17 from rjw@sisk.pl  2008-11-05 02:48 -------
Caused by:

commit f0c0a376d0fcd4c5579ecf5e95f88387cba85211
Author: Mike Christie <michaelc@cs.wisc.edu>
Date: =C2=A0 Sun Aug 17 15:24:38 2008 -0500

=C2=A0 =C2=A0 [SCSI] Add helper code so transport classes/driver can co=
ntrol queueing
(v3)

    Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.c=
om>

Handled-By : James Bottomley <James.Bottomley@HansenPartnership.com>


--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
