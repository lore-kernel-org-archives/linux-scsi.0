From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: TMSCSIM [2.6]
Date: Sun, 30 Nov 2003 14:27:37 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC97FC9.10701@yk.rim.or.jp>
References: <Pine.LNX.4.44.0311291030500.1672-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pl411.nas911.n-yokohama.nttpc.ne.jp ([210.139.38.155]:12486
	"EHLO standard.erephon") by vger.kernel.org with ESMTP
	id S264796AbTK3F16 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2003 00:27:58 -0500
Received: from (client is using the wrong hostname!) yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m1AQK7X-0039AAC@standard.erephon> (Debian Smail3.2.0.115)
	for <linux-scsi@vger.kernel.org>; Sun, 30 Nov 2003 14:27:47 +0900 (JST)
In-Reply-To: <Pine.LNX.4.44.0311291030500.1672-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>, gl@dsa-ac.de

Guennadi Liakhovetski wrote:
> On Sat, 29 Nov 2003, Chiaki wrote:
> 
> 
>>Also, I disabled kernel preemption after reading your post.
>> From my .config:
>>   # CONFIG_PREEMPT is not set
> 
> 
> Ok, then it worked (except for that misterious first try). Can you switch
> preemption on again, so we can check for sure that it's my last
> modification, that fixed your problem and not switching preemption off.
> 
Hello,

I recompiled the kernel with preemption enabled this time.

tmscsim module loaded successfully.
So it was your patch that corrected the problem.

Thank you again!


PS: As for indentation, as others suggested,

  - functional patch.
  - incorporation into the main tree.
  - possible indentation patch afterward.

seems to be the best steps to follow.



-- 
int main(void){int j=2003;/*(c)2003 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="g>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */

