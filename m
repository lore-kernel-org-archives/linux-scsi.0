From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Fri, 31 Jul 2009 15:37:44 GMT
Message-ID: <200907311537.n6VFbitS021997@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40566 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZGaPhn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2009 11:37:43 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6VFbi7Y021998
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2009 15:37:44 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783





--- Comment #14 from Kay Sievers <kay.sievers@vrfy.org>  2009-07-31 15:37:43 ---
On Fri, Jul 31, 2009 at 11:33, <bugzilla-daemon@bugzilla.kernel.org> wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13783

> I don't know how to strace only hald-addon-storage, because it is a child
> process of hald and not an executable,

You should be able to just attach strace to the running process with "-p
<pid>".

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
