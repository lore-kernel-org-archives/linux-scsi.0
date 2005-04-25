From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: RE: Wireless transport?
Date: Mon, 25 Apr 2005 22:08:32 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0504252157150.9503@poirot.grange>
References: <Pine.LNX.4.60.0504242111090.3098@poirot.grange>
 <20050425010723.GA2734@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:31151 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262770AbVDYUL3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2005 16:11:29 -0400
In-Reply-To: <20050425010723.GA2734@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>, Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Thanks for the replies

On Sun, 24 Apr 2005, Guy wrote:

> My guess is the thing is a SAMBA server or similar.

Yeah, logical:-) Didn't think about that.

On Sun, 24 Apr 2005, Patrick Mansfield wrote:

> No, just use iSCSI on top of the network.

Sure, that'd be doable. Just have no idea - isn't it too much overhead? 
Say, over bluetooth, IP is already pretty high on the stack. OTOH, one 
could, possibly, take advantage of some features natively present in lower 
wireless levels, that don't get exported over IP?

Disclaimer: I am quite ignorant about wireless as well as iSCSI internals, 
so, feel free to ignore me, if I am talking nonsense, however, would be 
grateful for any education:-)

Thanks
Guennadi
---
Guennadi Liakhovetski

