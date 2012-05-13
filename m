From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43234] kernel crashes whenever the thumbdrive or USB devices
 are remove
Date: Sun, 13 May 2012 06:43:39 +0000 (UTC)
Message-ID: <20120513064339.37DAA11FCE3@bugzilla.kernel.org>
References: <bug-43234-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46128 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2EMGnm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 May 2012 02:43:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 21960203C2
	for <linux-scsi@vger.kernel.org>; Sun, 13 May 2012 06:43:41 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 3E341203D9
	for <linux-scsi@vger.kernel.org>; Sun, 13 May 2012 06:43:39 +0000 (UTC)
In-Reply-To: <bug-43234-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43234





--- Comment #1 from Peter Teoh <htmldeveloper@gmail.com>  2012-05-13 06:43:38 ---
Looked at the photostream:

http://www.flickr.com/photos/29072599@N08/with/7180142770/

it is a collection of the numerous crashes (7 on the same machine/OS version
across a period.

The crashed point happened at different position in the kernel, but is usually
associated with pulling out the USB devices without gracefully un-mounting it
in the first place.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
