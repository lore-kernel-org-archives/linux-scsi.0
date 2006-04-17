From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: [Bug 5659] Adaptec 29160 Ultra160 SCSI doesn't work with 2.6.14
 or +
Date: Tue, 18 Apr 2006 08:11:54 +0900
Message-ID: <444420BA.2020709@yk.rim.or.jp>
References: <BAY112-F188649A1A87780776413D9A0C70@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 31.79.150.220.ap.yournet.ne.jp ([220.150.79.31]:13720 "EHLO
	standard.erephon") by vger.kernel.org with ESMTP id S1751362AbWDQXPj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Apr 2006 19:15:39 -0400
Received: from [127.0.0.1] (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m1FVct1-002GJKC@standard.erephon> (Debian Smail3.2.0.115)
	for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2006 08:12:03 +0900 (JST)
In-Reply-To: <BAY112-F188649A1A87780776413D9A0C70@phx.gbl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mun Hamlet <hamletmun@hotmail.com>
Cc: linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org

Hi,

Just for comparison purposes, I have an Adaptec 29160 in my PC and
it runs just fine under 2.6.15.

To wit,

ishikawa@duron$ uname -a
Linux duron 2.6.15.6-test-tmscsim #6 Wed Mar 29 02:02:01 JST 2006 i686 GNU/Linux
ishikawa@duron$ dmesg | grep 160
        <Adaptec 29160 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
 target0:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
ishikawa@duron$


I suspect that there may be some configuration issues. I mean maybe some
configuration differences might explain why your box sees the problem while mine
doesn't.

I notice that I don't have libata, for example, since I  have no
sata disks in my two/three years old PC.

It might be wise to forget about 2.6.14 and try the latest 2.6.15.x series.


Mun Hamlet wrote:
> After git bisecting... I found this
> http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=d0a7e574007fd547d72ec693bfa35778623d0738;hp=10c1b88987d618f4f89c10e11e574c76de73b5e7 
> 
> 
> could be causing the problem.
> 
> To verify the result, I applied this patch to vanilla 2.6.13
> At least it boots, but this is the output I obtained:
> 
 ... omission ...


-- 
int main(void){int j=2006;/*(c)2006 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="d>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=(int)strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */
