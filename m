From: John Hasler <john@dhh.gt.org>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Thu, 25 Mar 2004 21:23:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <87smfw9tqi.fsf@toncho.dhh.gt.org>
References: <81ptb0wh45.wl@omega.webmasters.gr.jp>
	<MDEHLPKNGKAHNMBLJOLKAEFILEAA.davids@webmaster.com>
	<20040326025909.GY9248@cheney.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa-4.airstreamcomm.net ([64.33.192.164]:33286 "EHLO
	sa-4.airstreamcomm.net") by vger.kernel.org with ESMTP
	id S263662AbUCZDRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2004 22:17:53 -0500
In-Reply-To: <20040326025909.GY9248@cheney.cx> (Chris Cheney's message of
 "Thu, 25 Mar 2004 20:59:09 -0600")
List-Id: linux-scsi@vger.kernel.org
To: 239952@bugs.debian.org, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Chris writes:
> So is a reverse engineered driver where there is a binary blob the
> preferred form of source?

Where did the blob come from?  If the author wrote it in binary (unlikely),
then it's ok.  If he wrote it in hex (I've done that) he should supply a
hex file from which the blob can be generated.

> Of course reverse engineered drivers with binary blobs in them are
> probably copyright infringements anyway...

If the author ripped the blob out of someone else's closed-source binary
driver it certainly is.  It also is a GPL violation.
-- 
John Hasler               You may treat this work as if it 
john@dhh.gt.org           were in the public domain.
Dancing Horse Hill        I waive all rights.
Elmwood, Wisconsin
