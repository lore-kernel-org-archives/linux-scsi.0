From: "Kai OM" <epimetreus@fastmail.fm>
Subject: Re: Sym53c8xx_2
Date: Tue, 17 Aug 2004 06:19:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092737963.28193.202482480@webmail.messagingengine.com>
References: <1092366037.28144.202254467@webmail.messagingengine.com>
   <Pine.LNX.4.60.0408132049060.4069@poirot.grange>
   <1092432298.18813.202307545@webmail.messagingengine.com>
   <Pine.LNX.4.60.0408150005570.5333@poirot.grange>
   <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local>
   <1092624889.15338.202386294@webmail.messagingengine.com>
   <Pine.LNX.4.58.0408162051470.5241@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from frontend1.messagingengine.com ([66.111.4.30]:14240 "EHLO
	frontend1.messagingengine.com") by vger.kernel.org with ESMTP
	id S264808AbUHQKTX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 06:19:23 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0408162051470.5241@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org


On Mon, 16 Aug 2004 21:02:49 +0300 (EEST), "Kai Makisara"
<Kai.Makisara@kolumbus.fi> said:

> > I'm pretty sure at least one other person I know that had this problem
> > was using a very similar chipset/controller, which strikes me as
> > pertinent.
> > 
> I am sorry to break this theory ;-)

Well, it weakens it, but it could always also be an issue with very
specific chipset revisions, or something more obscure. I can't test to
say that you're wrong, so I'd like someone who gets the same errors as
me(ABORT operations followed by device, bus, and host resets, for those
newly reading this thread) to try the tests suggested -- namely, moving
devices and controllers around, to see which the problem follows.

Could anyone who's gotten this error do some swapping around so we can
get some more data?
