From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195285] qla2xxx FW immediatly crashing after target start
Date: Fri, 19 May 2017 16:44:41 +0000
Message-ID: <bug-195285-11613-vvIdHiCKYU@https.bugzilla.kernel.org/>
References: <bug-195285-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60480 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751208AbdESQom (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 12:44:42 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CFDB1284A6
        for <linux-scsi@vger.kernel.org>; Fri, 19 May 2017 16:44:41 +0000 (UTC)
In-Reply-To: <bug-195285-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195285

--- Comment #12 from himanshu.madhani@cavium.com (himanshu.madhani@qlogic.com) ---
(In reply to loberman from comment #11)
> ----- Original Message -----
> > From: "Laurence Oberman" <loberman@redhat.com>
> > To: bugzilla-daemon@bugzilla.kernel.org
> > Cc: linux-scsi@kernel.org
> > Sent: Thursday, May 18, 2017 2:11:43 PM
> > Subject: Re: [Bug 195285] qla2xxx FW immediatly crashing after target start
> > 
> > 
> > 
> > ----- Original Message -----
> > > From: bugzilla-daemon@bugzilla.kernel.org
> > > To: linux-scsi@kernel.org
> > > Sent: Thursday, May 18, 2017 2:09:51 PM
> > > Subject: [Bug 195285] qla2xxx FW immediatly crashing after target start
> > > 
> > > https://bugzilla.kernel.org/show_bug.cgi?id=195285
> > > 
> > > --- Comment #6 from himanshu.madhani@cavium.com
> > > (himanshu.madhani@qlogic.com)
> > > ---
> > > Hi Anthony, Laurence,
> > > 
> > > Can you try attached patch to see if it works for you?
> > > 
> > > if Yes, I'll send out to SCSI mailing list to be included into upstream.
> > > 
> > > Thanks,
> > > Himanshu
> > > 
> > > --
> > > You are receiving this mail because:
> > > You are watching the assignee of the bug.
> > > 
> > Absolutely, and thanks
> > Regards
> > Laurence
> 
> Its working fine for me too now
> Thanks!!
> Laurence

Thanks Laurence. Appreciate your effort on testing this out.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
