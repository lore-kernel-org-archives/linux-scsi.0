From: Ali Akcaagac <aliakc@web.de>
Subject: Re: [Dc395x] Re: [PATCH] dc395x - 1/3 remove-static-eeprom-struct
Date: Sun, 03 Aug 2003 17:36:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059924971.5837.5.camel@localhost>
References: <20030803082718.GA4594@twibble.org>
	 <20030803082759.GA4611@twibble.org>  <1059922898.10960.3.camel@mulgrave>
	 <1059923048.5692.1.camel@localhost>  <1059923631.10853.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.web.de ([217.72.192.158]:19487 "EHLO smtp.web.de")
	by vger.kernel.org with ESMTP id S271222AbTHCPgX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2003 11:36:23 -0400
In-Reply-To: <1059923631.10853.6.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jamie Lenehan <lenehan@twibble.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2003-08-03 at 17:13, James Bottomley wrote:
> Ah, OK, the driver's coming through the -ac tree. OK, I'll
> revert the current change I have in the scsi tree from you
> so as not to damage the merge.

Well the driver got in during 2.5.7x times through Linus himself after
we sent him the initial stuff we did. During that time we made around
250-270kb of changes to the driver which we had some problems getting in
due to the size. Around 2 weeks ago I contacted Alan Cox if he may
review the changes we made during that time and if he could get it in
somehow. So the changes (the 2500-2800 lines) showed up in the AC tree 1
week ago and now got merged into the test2-bk1/2 tree some days ago.
During the merge there seemed to be a one char issue in bk2 which
prevented the driver from compiling, that's why I sent in a little one
liner patch that fixes this behaviour.

Jamie Lenehan fixed that stuff correctly now (because there was some XXX
Fixme's in the code) as you see thats the 3 patches Jamie sent to the
scsi list today/yesterday (depends on the timezone). These 3 patches
should go against bk2 (which I have tested this morning) works and
applies without any problems.

So if possible please add these 3 patches ontop of what's inside bk2,
this will save us a lot of pain :)

greetings,

Ali Akcaagac

