From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: 2.6test10: Annoying "CDROM not ready" messages once a second
Date: Wed, 26 Nov 2003 23:45:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m37k1mrbp8.fsf@merlin.emma.line.org>
References: <20031126134041.25698.qmail@mailshell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:1742 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S264363AbTKZWp0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2003 17:45:26 -0500
Received: from m2a2.dyndns.org (krusty.dt.e-technik.uni-dortmund.de [129.217.163.1])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id 1DA65155E6
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2003 23:45:25 +0100 (CET)
In-Reply-To: <20031126134041.25698.qmail@mailshell.com> (linux-scsi's
 message of "Wed, 26 Nov 2003 15:41:38 +0200")
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi-031126@amos.mailshell.com
Cc: linux-scsi@vger.kernel.org

linux-scsi-031126@amos.mailshell.com writes:

> My system is an AMD Athlon, no SCSI devices (I need generic SCSI only
> for cd burning software and USB access, I'm aware that it's supposed to
> be gone in 2.6 but the software I use is still not aware of this).
> Preemption enabled (no problems from that part).

Updating your CD burning software to a more recent alpha version may rid
you of the requirement for a non-working ide-scsi emulation. I'm using
cdrecord 2.01a19 without sg stuff. Worksforme[tm].

> Please CC me with replys, I'm not on the list.

done.

-- 
Matthias Andree

Encrypt your mail: my GnuPG key ID is 0x052E7D95
