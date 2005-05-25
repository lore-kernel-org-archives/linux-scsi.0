From: "open_iscsi" <ESQuicksall_open_iscsi@Comcast.net>
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Wed, 25 May 2005 09:08:03 -0400
Message-ID: <000d01c5612a$c91367a0$03031eac@ivivity.com>
References: <42936441.0b798bab.39a4.ffff9774SMTPIN_ADDED@mx.googlegroups.com> <42939610.3070104@cs.wisc.edu> <1116976678.7710.34.camel@mulgrave> <000b01c560c0$42c59700$03031eac@ivivity.com> <1116982816.7710.58.camel@mulgrave> <001101c560c9$0870f280$03031eac@ivivity.com> <1117026039.5527.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="Windows-1252";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc12.comcast.net ([204.127.202.56]:4237 "EHLO
	sccrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S262340AbVEYNII (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 09:08:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

yes and no ...

For single session, yes.

For multiple sessions, no ... lots of different initiators with aggragate of 
400K into single target.

Eddy

----- Original Message ----- 
From: "Ming Zhang" <mingz@ele.uri.edu>
To: "open-iscsi" <open-iscsi@googlegroups.com>
Cc: "James Bottomley" <James.Bottomley@SteelEye.com>; "Mike Christie" 
<michaelc@cs.wisc.edu>; "'SCSI Mailing List'" <linux-scsi@vger.kernel.org>
Sent: Wednesday, May 25, 2005 9:00 AM
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi

about this 400K IOPS, both ini and target are using your HW solution?

ming

On Tue, 2005-05-24 at 21:28 -0400, open_iscsi wrote:
> Regarding the numbers, we get 400,000 IOPS with our hardware solution
> using
> multiple connections and multiple micro-engines. I have not tried
> multi-pathing but I can tell you that I had to count clocks to get
> that
> number and found that even a few extra clocks could mean a lot. So
> since
> multi-pathing takes a lot of extra clocks, then I think there is a
> benefit.
> However with a software solution the extra clocks for the multi-
> pathing may
> not be significant.

