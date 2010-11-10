From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22512] no disks are found at driver start after upgrate from
 2.6.35.8 to 2.6.36
Date: Wed, 10 Nov 2010 19:56:50 GMT
Message-ID: <201011101956.oAAJuoP2032249@demeter1.kernel.org>
References: <bug-22512-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:41263 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab0KJT4w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2010 14:56:52 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAAJuou0032250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2010 19:56:50 GMT
In-Reply-To: <bug-22512-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=22512





--- Comment #4 from cunio@agora.pl  2010-11-10 19:56:47 ---
(In reply to comment #3)
> Apologize, that was the wrong link.  Try this one:
> 
>     [SCSI] qla2xxx: Add module parameter to enable/disable GFF_ID device type
> check.                                            
> 
>     Add the module parameter ql2xgffidenable to disable/enable the use of the   
>     GFF_ID name server command to prevent non FCP SCSI devices from being added
> to                                              
>     the driver's internal fc_port database.
> 
>    
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4da26e162b69d89c3186a35a052c05e61a555637

This is it.

May be somebody should build 2.6.36.1

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
