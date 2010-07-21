From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 16275] Kernel panic when mounting filesystem
Date: Wed, 21 Jul 2010 13:43:41 -0700
Message-ID: <1279745021.20250.44.camel@mulgrave.site>
References: <bug-16275-11613@https.bugzilla.kernel.org/>
	 <201007200957.o6K9vaXx014277@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab0GUUnq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 16:43:46 -0400
In-Reply-To: <201007200957.o6K9vaXx014277@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-07-20 at 09:57 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> --- Comment #9 from Pawel Staszewski <pstaszewski@artcom.pl>  2010-07-20 09:57:34 ---
> Created an attachment (id=27167)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=27167)
> Panic first screen

Well, this validates the guess that it's the zero segment check, thanks!
so it's clearly a filesystem bug.

Which filesystem is this?  I tried looking for the 'Checking internal
tree' message, but couldn't find it in the sources.

James



