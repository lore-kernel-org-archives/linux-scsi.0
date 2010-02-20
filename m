From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15362] MPT Fusion SCSI drives no longer appear - suspect PCI
 bus scan bug
Date: Sat, 20 Feb 2010 15:05:37 GMT
Message-ID: <201002201505.o1KF5bl1026764@demeter.kernel.org>
References: <bug-15362-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47138 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab0BTPFi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2010 10:05:38 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1KF5bm5026765
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 20 Feb 2010 15:05:37 GMT
In-Reply-To: <bug-15362-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15362





--- Comment #1 from Sean M. Pappalardo <pegasus@renegadetech.com>  2010-02-20 15:05:37 ---
Created an attachment (id=25131)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=25131)
lspci -n on 2.6.26

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
