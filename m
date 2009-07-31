From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Fri, 31 Jul 2009 15:33:22 GMT
Message-ID: <200907311533.n6VFXMbg021099@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48665 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZGaPdW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2009 11:33:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6VFXM5X021100
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2009 15:33:22 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783





--- Comment #13 from Andreas Fackler <AndreasFackler@web.de>  2009-07-31 15:33:19 ---
Created an attachment (id=22553)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=22553)
strace -f hald

I dont't know how to strace only hald-addon-storage, because it is a child
process of hald and not an executable, so I did "strace -f hald". Within a few
seconds, this generated more than 5 MB of output. I attached the first megabyte
of it.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
