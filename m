From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Stanford Checker: buggy lock handling.
Date: Sat, 17 Jul 2004 00:07:01 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F7EF15.8040808@yk.rim.or.jp>
References: <B179AE41C1147041AA1121F44614F0B060EEDF@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pl1015.nas911.n-yokohama.nttpc.ne.jp ([210.139.42.247]:50398
	"EHLO standard.erephon") by vger.kernel.org with ESMTP
	id S266534AbUGPPHK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 11:07:10 -0400
Received: from [127.0.0.1] (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m1BlUIi-00391dC@standard.erephon> (Debian Smail3.2.0.115)
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jul 2004 00:07:04 +0900 (JST)
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060EEDF@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I noticed that Stanford Checker project
summarized their finding concerning lock handling
and posted it to LKML.
I noticed a few SCSI files are mentioned as buggy in their
report.

http://lwn.net/Articles/92784/
http://glide.stanford.edu/linux-lock/err1.html
http://glide.stanford.edu/linux-lock/err2.html


If these have been taken care of already, great.
But if not, maybe something ought to be done about it.



-- 
int main(void){int j=2003;/*(c)2003 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="g>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */
