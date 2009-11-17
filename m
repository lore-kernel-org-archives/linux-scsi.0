From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14577] Data Corruption with Adaptec 52445, Firmware 5.2-0
 (17380)
Date: Tue, 17 Nov 2009 22:44:02 GMT
Message-ID: <200911172244.nAHMi2vu006716@demeter.kernel.org>
References: <bug-14577-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60095 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301AbZKQWnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 17:43:55 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHMi20m006717
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2009 22:44:02 GMT
In-Reply-To: <bug-14577-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14577





--- Comment #9 from Rafael J. Wysocki <rjw@sisk.pl>  2009-11-17 22:44:00 ---
On Tuesday 17 November 2009, Lukas Kolbe wrote:
> Rafael J. Wysocki wrote:
> 
> >This message has been generated automatically as a part of a report
> >of recent regressions.
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.31.  Please verify if it still should be listed and let me know
> >(either way).
> 
> It is still valid. We haven't yet been able to verify if it is either a
> hardware problem (working with the adaptec folks to sort that out) or a
> kernel problem (working with you to find that out ;). Kernel 2.6.30, as
> already said, seems to think everything is fine, so it really might be a
> regression.
> 
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14577
> >Subject		: Data Corruption with Adaptec 52445, Firmware 5.2-0 (17380)
> >Submitter	:  <lkolbe@techfak.uni-bielefeld.de>
> >Date		: 2009-11-10 13:31 (7 days old)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.