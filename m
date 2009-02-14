From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12662] linux 2.6.29-rc3 kernel failure with mptsas
Date: Sat, 14 Feb 2009 14:04:09 -0800 (PST)
Message-ID: <20090214220409.E71F411D10B@picon.linux-foundation.org>
References: <bug-12662-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbZBNWEM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Feb 2009 17:04:12 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1EM4AKL010937
	for <linux-scsi@vger.kernel.org>; Sat, 14 Feb 2009 14:04:11 -0800
In-Reply-To: <bug-12662-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D12662





------- Comment #1 from rjw@sisk.pl  2009-02-14 14:04 -------
On Saturday 14 February 2009, Morten P.D. Stevens wrote:
> Update:
>=20
> today i installed linux 2.6.29-rc5 and there a no problems?
>=20
> no errors or kernel failures in dmesg.
>=20
> linux 2.6.29-rc5 works fine but something is strange:
>=20
> > -	init_timer(&pCfg->timer);
> > +	init_timer_on_stack(&pCfg->timer);
>=20
> this wasn't changed?
>=20
> Anyway it=B4s working fine with 2.6.29-rc5, now.


--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
