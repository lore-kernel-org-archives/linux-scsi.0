From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15001] megaraid_sas fills dmesg with megasas: Failed to copy
 out to user sense data
Date: Fri, 5 Feb 2010 14:51:42 GMT
Message-ID: <201002051451.o15EpgVI008524@demeter.kernel.org>
References: <bug-15001-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35802 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab0BEOvm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2010 09:51:42 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o15Epg4q008526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 5 Feb 2010 14:51:42 GMT
In-Reply-To: <bug-15001-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15001





--- Comment #11 from Tomas Henzl <thenzl@redhat.com>  2010-02-05 14:51:36 ---
(In reply to comment #10) 
> I guess it is ok , 
> OMSA is 6.0.1-8 . For example 
> omreport storage vdisk 
> omreport storage pdisk controller=0 
> works as expected .
OK, thanks for testing.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
