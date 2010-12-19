From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22092] Kernel v2.6.36 trouble on USB disconnect
Date: Sun, 19 Dec 2010 14:45:01 GMT
Message-ID: <201012191445.oBJEj1eN012925@demeter2.kernel.org>
References: <bug-22092-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:42874 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0LSOpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Dec 2010 09:45:03 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBJEj1CL012968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 19 Dec 2010 14:45:02 GMT
In-Reply-To: <bug-22092-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=22092





--- Comment #3 from Rafael J. Wysocki <rjw@sisk.pl>  2010-12-19 14:44:59 ---
On Sunday, December 19, 2010, Heinz Diehl wrote:
> On 19.12.2010, Rafael J. Wysocki wrote: 
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.35 and 2.6.36.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22092
> > Subject		: Kernel v2.6.36 trouble on USB disconnect
> > Submitter	: Ketil Froyn <ketil@froyn.name>
> > Date		: 2010-10-29 8:05 (52 days old)
> > Message-ID	: <AANLkTik5qVxkEGVAA1PSOGk2KTW+ekHpSwttsQEWzWj+@mail.gmail.com>
> > References	: http://marc.info/?l=linux-kernel&m=128833956503607&w=2
> 
> I guess this may be a duplicate of this one:
> http://bugzilla.kernel.org/show_bug.cgi?id=24722

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.