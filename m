From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 22512] New: no disks are found at driver start
 after upgrate from 2.6.35.8 to 2.6.36
Date: Mon, 22 Nov 2010 16:26:27 -0800
Message-ID: <20101122162627.35f899de.akpm@linux-foundation.org>
References: <bug-22512-10286@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab0KWA1A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2010 19:27:00 -0500
In-Reply-To: <bug-22512-10286@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stable@kernel.org
Cc: linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Tue, 9 Nov 2010 19:53:21 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=22512

>From this bug report it appears that
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4da26e162b69d89c3186a35a052c05e61a555637
is needed in 2.6.36.x to fix a 2.6.35->2.6.36 regression.

But nobody remembered to add cc:<stable@kernel.org> to the changelog,
so it got lost.
