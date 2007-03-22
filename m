From: "Mr. Berkley Shands" <bshands@exegy.com>
Subject: 2.6.20 (+2.6.21-rc4) write hang modifier
Date: Thu, 22 Mar 2007 12:40:42 -0500
Message-ID: <4602BF9A.2080402@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 68-191-203-42.static.stls.mo.charter.com ([68.191.203.42]:31328
	"EHLO service.eng.exegy.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934153AbXCVRlz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2007 13:41:55 -0400
Content-Class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Dave Lloyd <dlloyd@exegy.com>

If I set /proc/sys/vm/dirty_ratio to "5" the write lockup happens within
the first MilliSecond, at about 100MB per file system.
If I slew the dirty_ratio to 80, the lockup happens
at about 2GB per file system.

2.6.21-rc4 has the same symptoms, and same lockups.
It appears that mptsas is dropping something.

berkley

-- 

//E. F. Berkley Shands, MSc//

**Exegy Inc.**

3668 S. Geyer Road, Suite 300

St. Louis, MO  63127

Direct:  (314) 450-5348

Cell:  (314) 303-2546

Office:  (314) 450-5353

Fax:  (314) 450-5354

 

The Usual Disclaimer follows...
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not use or disclose the content to others.
