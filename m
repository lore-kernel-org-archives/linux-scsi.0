From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14579] Devices disappear; on bus reset machine hangs; on I/O
 machine hangs
Date: Mon, 25 Jan 2010 13:23:14 GMT
Message-ID: <201001251323.o0PDNE1W030742@demeter.kernel.org>
References: <bug-14579-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42360 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab0AYNXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2010 08:23:14 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0PDNEVK030743
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2010 13:23:14 GMT
In-Reply-To: <bug-14579-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14579


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
     Kernel Version|Linux version               |2.6.30-1-amd64 Debian
                   |2.6.30-1-amd64 (Debian      |
                   |2.6.30-5+techfaklenny1)     |
                   |(sfrey@TechFak.Uni-Bielefel |
                   |d.DE) (gcc version 4.3.2    |
                   |(Debian 4.3.2-1.1) ) #1 SMP |
                   |Sat Aug 15 11:20:08 UTC     |
                   |2009                        |




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
