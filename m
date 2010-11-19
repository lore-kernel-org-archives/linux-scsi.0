From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16971] qla4xxx compile failure on 32-bit PowerPC: missing readq
 and writeq
Date: Fri, 19 Nov 2010 20:06:53 GMT
Message-ID: <201011192006.oAJK6rVJ002268@demeter1.kernel.org>
References: <bug-16971-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:48300 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab0KSUGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2010 15:06:54 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAJK6r2J002269
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2010 20:06:53 GMT
In-Reply-To: <bug-16971-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16971





--- Comment #5 from Rafael J. Wysocki <rjw@sisk.pl>  2010-11-19 20:06:51 ---
On Friday, November 19, 2010, Meelis Roos wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> > Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> > Submitter	: Meelis Roos <mroos@linux.ee>
> > Date		: 2010-08-19 21:03 (92 days old)
> > Message-ID	: <<alpine.SOC.1.00.1008192359310.19654@math.ut.ee>>
> > References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2
> 
> Still unfixed in mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.