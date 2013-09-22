From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: Areca RAID Controler and commit 98dcc2946adbe4349ef1ef9b99873b912831edd4
Date: Sun, 22 Sep 2013 19:29:35 +0200
Message-ID: <828dd47f-7395-4a0d-8a7c-e6a43eb152e6@email.android.com>
References: <CAALC5YEG7Lp=q1n0SuCLOXizY8rN4FLJ-5VJ44WO9AmOPYJdBw@mail.gmail.com> <1379869539.11624.21.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49089 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab3IVRaX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Sep 2013 13:30:23 -0400
In-Reply-To: <1379869539.11624.21.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, "Christian Bahls - gmail.com" <christian.bahls@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <jbottomley@parallels.com> wrote:
>[cc to linux-scsi added]
>On Sun, 2013-09-22 at 16:27 +0200, Christian Bahls - gmail.com wrote:
>> Dear all,
>> 
>> Looks like i have been bitten by the above mentioned commit.
>
>Just from a practical point of view, I only really work upstream, so
>this commit id doesn't show anything for me. I think the commit you're
>referring to is:
>
>commit 66c28f97120e8a621afd5aa7a31c4b85c547d33d
>Author: Martin K. Petersen <martin.petersen@oracle.com>
>Date:   Thu Jun 6 22:15:55 2013 -0400
>
>    [SCSI] sd: Update WRITE SAME heuristics
>
>> I have several root server at German Hoster 1 & 1 (United Internet)
>> 
>> I have been updating my Kernel to version 3.10 recently - using
>> Debians update mechanism -and loosing the server afterwards
>> 
>> As lots of people will have this hardware -at leas in that
>datacenter-
>> will the fix mentioned in https://lwn.net/Articles/561356/ be hitting
>> linux-stable anytime soon?
>
>It's been there for months.  It went to stable at the end of June.  If
>I
>look at the tree, it was in 3.10.3.  Debian testing is already on
>3.10.7 ... not sure what the rest has because I only run testing.
>
>James

I'm still on my way back and checking commits with my mobile is a bit difficult. I guess Christan suffers from that heuristics commit and needs the other patch Martin acked on Friday. I'm going to re-send it as soon as I'm tomorrow on my desk. 

Cheers, Bernd


