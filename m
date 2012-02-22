From: "Loke, Chetan" <Chetan.Loke@netscout.com>
Subject: RE: [PATCH 1/1] qla2xxx: Micro optimization in queuecommand handler
Date: Wed, 22 Feb 2012 14:06:29 -0500
Message-ID: <D3F292ADF945FB49B35E96C94C2061B915FD6417@nsmail.netscout.com>
References: <1329230866-905-1-git-send-email-loke.chetan@gmail.com> <D3F292ADF945FB49B35E96C94C2061B915FD62A2@nsmail.netscout.com> <alpine.WNT.2.00.1202221346030.6020@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:39182 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752479Ab2BVTGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:06:33 -0500
Content-class: urn:content-classes:message
In-Reply-To: <alpine.WNT.2.00.1202221346030.6020@N5102REMCQXM4BS.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, lokechetan@gmail.com

> From: Chad Dupuis [mailto:chad.dupuis@qlogic.com]
> Sent: February 22, 2012 1:49 PM
> To: Loke, Chetan
> Cc: JBottomley@parallels.com; linux-scsi@vger.kernel.org; Andrew
> Vasquez; Dept-Eng Linux Driver; lokechetan@gmail.com
> Subject: RE: [PATCH 1/1] qla2xxx: Micro optimization in queuecommand
> handler
> 
> 
.......
> 
> >> Optimized queuecommand handler's to eliminate double head-room
checks.
> >> The checks are moved inside the 1st if-loop otherwise you would end
up
> >> checking twice when there is enough head room.
> >>
> >> Signed-off-by: Chetan Loke <loke.chetan@gmail.com>
> >> ---
> >
> > Ping...
> >
> 
> Hi Chetan,
> 
> We have picked this up and it will be part of our next submission.
> Since this affects the I/O path we wanted to have this patch go
through one
> of our full test cycles.
> 

No problem. Thanks for the update Chad.

> Thanks,
> Chad

Chetan

