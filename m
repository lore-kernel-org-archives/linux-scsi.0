From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Wed, 25 Nov 2009 09:47:02 GMT
Message-ID: <200911250947.nAP9l2JW027887@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46242 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530AbZKYJq4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2009 04:46:56 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAP9l2E1027888
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2009 09:47:02 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563


Joachim Breuer <linux-kernel@jmbreuer.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #23877|0                           |1
        is obsolete|                            |




--- Comment #21 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-25 09:47:00 ---
Created an attachment (id=23929)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23929)
Console output, 2.6.30.3, fixed tape block size 512k, patch by FUJITA Tomonori
2009-11-19, really this time

Sorry about that. Insufficient sleep, insufficient coffee :-/

Attached is the log when really, actually, using FUJITA Tomonori's patch from
2009-11-19.

The two-fold good news:

a) amflush worked correctly, no EIO, no BUG
I'll still read this tape back in for verification and post a quick comment
about the result.

b) DIO apparently was used: "st0: Number of r/w requests 38867, dio used in
138, pages 17664."

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
