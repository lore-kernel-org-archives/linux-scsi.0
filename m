From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16971] qla4xxx compile failure on 32-bit PowerPC: missing readq
 and writeq
Date: Wed, 22 Sep 2010 18:04:47 GMT
Message-ID: <201009221804.o8MI4lkN028342@demeter2.kernel.org>
References: <bug-16971-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:54083 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0IVSEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2010 14:04:48 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8MI4loS028343
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2010 18:04:47 GMT
In-Reply-To: <bug-16971-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16971





--- Comment #3 from Rafael J. Wysocki <rjw@sisk.pl>  2010-09-22 18:04:46 ---
On Wednesday, September 22, 2010, Meelis Roos wrote:
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> > > > Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> > > > Submitter	: Meelis Roos <mroos@linux.ee>
> > > > Date		: 2010-08-19 21:03 (33 days old)
> > > 
> > > Still present. The maintainer of the driver has a patch that I have 
> > > tested, and for quite some time now, but it still does not appear in 
> > > mainline.
> > 
> > Do you have a pointer to the maintainer and the patch, so that we can
> > update the bugzilla entry and ping the maintainer? 
> 
> The patch was made by Vikas Chaudhary <vikas.chaudhary@qlogic.com> 
> (CC:d) and sent to me by private me-mail. I was first dubious about 
> possible endianness problem with qla4xxx private readq and writeq 
> implementation but he told they forcefully tested it on PPC64 and it 
> worked.
> 
> Last I heard from him on September 6th when he wrote he intended to push 
> the patch upstream together with other patches the same week.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.