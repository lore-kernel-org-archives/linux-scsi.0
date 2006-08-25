From: Jes Sorensen <jes@sgi.com>
Subject: Re: qla1280 bugfix in limbo?
Date: 25 Aug 2006 07:14:05 -0400
Message-ID: <yq07j0xt6de.fsf@jaguar.mkp.net>
References: <F3598542BAC24B4783B7A440D45522FF04B5D899@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:60837 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S1751079AbWHYLOG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Aug 2006 07:14:06 -0400
In-Reply-To: <F3598542BAC24B4783B7A440D45522FF04B5D899@usahm236.amer.corp.eds.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bailey, Scott" <scott.bailey@eds.com>
Cc: 366730@bugs.debian.org, linux-scsi@vger.kernel.org

>>>>> "Scott" == Bailey, Scott <scott.bailey@eds.com> writes:

Scott> Just tuning in briefly to report: 1. I have been running my
Scott> 3-processor Alphaserver 4100 with Ian's patch
Scott> http://bugzilla.kernel.org/show_bug.cgi?id=6275 for a little
Scott> over a month now, first with 2.6.16 and now with 2.6.17, and it
Scott> continues to work like a champ. I very much would like to see
Scott> this fix incorporated into the Debian kernel or preferably
Scott> upstream, since my DLT drive is pretty much useless without it.

Scott> 2. Unfortunately, I see no sign that anybody has looked at the
Scott> kernel bugzilla report above.

The problem is that the person who submitted it didn't bother CC'ing
the driver maintainer so nobody was aware of the bug being in
bugzilla.

I just discovered it today and I just plan to test it before I push it
upstream.

Jes
