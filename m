From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15688] mptsas & poor performance
Date: Thu, 8 Apr 2010 10:31:21 GMT
Message-ID: <201004081031.o38AVLbm023376@demeter.kernel.org>
References: <bug-15688-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57131 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0DHKbW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2010 06:31:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o38AVLFp023377
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 8 Apr 2010 10:31:21 GMT
In-Reply-To: <bug-15688-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15688





--- Comment #2 from kdesai <kashyap.desai@lsi.com>  2010-04-08 10:31:17 ---
Andrew,

Today I tried same steps as mentioned by you. In my case I am able to see both
the drivers 
Performance is similar.

3.4.14 is driver version available at kernel.org
4.22.00.00 is driver LSI internally uses. [4.18.00.00 does not have support for
2.6.34 kernel]
I guess you must have done some changes to make sure 4.18.00.00 works with
2.6.34-020634rc1.

Both the case I am getting 190~210MB/sec.

Can you help me to reproduce ~395MB/sec using 4.18.00.00 ? 


~Kashyap 




> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Andrew Morton
> Sent: Tuesday, April 06, 2010 2:05 AM
> To: linux-scsi@vger.kernel.org; Moore, Eric
> Cc: bugzilla-daemon@bugzilla.kernel.org; bugme-
> daemon@bugzilla.kernel.org; bexamous@gmail.com
> Subject: Re: [Bugme-new] [Bug 15688] New: mptsas & poor performance
> 
> 
> (switched to email.  Please respond via emailed reply-to-all, not via
> the
> bugzilla web interface).
> 
> scsi_drivers-other reports don't appear to be coming out on the
> linux-scsi list.
> 
> On Sat, 3 Apr 2010 21:16:31 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=15688
> >
> >            Summary: mptsas & poor performance
> >            Product: SCSI Drivers
> >            Version: 2.5
> >     Kernel Version: 2.6.34-020634rc1
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Other
> >         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
> >         ReportedBy: bexamous@gmail.com
> >         Regression: No
> >
> >
> > The mptsas module from LSI's website, v4.18.00.00, performs much
> better than
> > the mptsas module included in the kernel, v3.something.
> >
> > I'm only comparing sequential writes (dd if=/dev/zero of=zeros
> bs=1M), but...
> >
> > 6 drive MD RAID5 with fresh btrfs, writing 10GB of zeros with dd,
> > kernel version:  <200MB/sec
> > LSI's v4.18.00.00: 395MB/sec
> >
> > Pretty big difference.  I've gone back and forth a few times,
> > enabling/disabling write cache on the drives, enabling/disabling ioc,
> > enabling/disabling filesystem barriers...  I can make small changes
> in
> > performance but nothing compares to simply updating to v4.18.00.00.
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
