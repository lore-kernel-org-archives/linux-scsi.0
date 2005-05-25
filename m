From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Wed, 25 May 2005 15:42:34 -0400
Message-ID: <1117050154.4760.1.camel@mulgrave>
References: <42936441.0b798bab.39a4.ffff9774SMTPIN_ADDED@mx.googlegroups.com>
	 <42939610.3070104@cs.wisc.edu> <1116976678.7710.34.camel@mulgrave>
	 <000b01c560c0$42c59700$03031eac@ivivity.com>
	 <1116982816.7710.58.camel@mulgrave>  <4294972D.4030807@adaptec.com>
	 <1117044247.5210.15.camel@mulgrave>  <1117045931.16262.149.camel@beastie>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:7297 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261558AbVEYUyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 16:54:07 -0400
In-Reply-To: <1117045931.16262.149.camel@beastie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Yusupov <dmitry_yus@yahoo.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, open_iscsi <ESQuicksall_open_iscsi@Comcast.net>, Mike Christie <michaelc@cs.wisc.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com

On Wed, 2005-05-25 at 11:32 -0700, Dmitry Yusupov wrote:
> Those are very strong arguments against having MC/S implemented for the
> software iSCSI initiator. Especially true is (a). Not that many targets
> offers MC/S, since according to RFC it implies ERL=2.
> 
> Now, back to open-iscsi initiator business and its mainline acceptance.
> We are going to met your requirement and will remove multi-connection
> support before next patch-set submission. As Mike C. mentioned before,
> it is fairly easy to do since the whole connection management resides in
> user-space. Though it will exists as a kernel patches on our web site
> (http://www.open-iscsi.org) for those who wonders.
> 
> Are there are some other requirements we need to met besides MC/S
> removal ?

Actually, I don't think so.  I'd like some convergence on what should be
in the transport class, since there have been a set of conflicting
patches from Mike Christie and Nicholas Bellinger, but that's not a
requirement ... what's there already can go in and we can sort out the
residue in-tree.

James


