From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16971] qla4xxx compile failure on 32-bit PowerPC: missing readq
 and writeq
Date: Wed, 13 Oct 2010 20:19:56 GMT
Message-ID: <201010132019.o9DKJuF2007002@demeter2.kernel.org>
References: <bug-16971-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:47042 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0JMUT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2010 16:19:57 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9DKJuDZ007003
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2010 20:19:56 GMT
In-Reply-To: <bug-16971-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16971





--- Comment #4 from Rafael J. Wysocki <rjw@sisk.pl>  2010-10-13 20:19:53 ---
On Wednesday, October 13, 2010, Meelis Roos wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> > Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> > Submitter	: Meelis Roos <mroos@linux.ee>
> > Date		: 2010-08-19 21:03 (53 days old)
> > Message-ID	: <alpine.SOC.1.00.1008192359310.19654@math.ut.ee>
> 
> Still present.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.