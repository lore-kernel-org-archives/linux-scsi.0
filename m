From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: TMSCSIM [2.6]
Date: Fri, 28 Nov 2003 10:41:04 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC6A7B0.3050401@yk.rim.or.jp>
References: <Pine.LNX.4.44.0311272106290.11508-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pl576.nas911.n-yokohama.nttpc.ne.jp ([210.139.39.64]:41162 "EHLO
	standard.erephon") by vger.kernel.org with ESMTP id S261807AbTK1Blc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2003 20:41:32 -0500
Received: from (client is using the wrong hostname!) yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m1APXdF-00393vC@standard.erephon> (Debian Smail3.2.0.115)
	for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2003 10:41:17 +0900 (JST)
In-Reply-To: <Pine.LNX.4.44.0311272106290.11508-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>

Guennadi Liakhovetski wrote:
> Please, try this:
> 
> diff -u linux-2.6.0-test10/drivers/scsi/scsiiom.c~ linux-2.6.0-test10/drivers/scsi/scsiiom.c
> --- linux-2.6.0-test10/drivers/scsi/scsiiom.c~  Mon Nov 24 23:47:29 2003
> +++ linux-2.6.0-test10/drivers/scsi/scsiiom.c   Thu Nov 27 23:02:35 2003
> @@ -1749,7 +1749,7 @@
>      pSRB->AdaptStatus = 0;
>      pSRB->TargetStatus = 0; /* CHECK_CONDITION<<1; */
> 
> -    pcmd = pSRB->pcmd;
> +//    pcmd = pSRB->pcmd;
> 
>      /* We are called from SRBdone, original PCI mapping has been removed
>       * already, new one is set up from StartSCSI */
> 
> Guennadi
> ---
> Guennadi Liakhovetski
> 

I am afraid that it didn't solve the problem.
I got the same kernel bug triggered at the same place.

I will try gcc 2.9x.y next to see if it makes a difference
and also it seems that test11 is out and so it will be tested as well.

Thank you again for your attention.




-- 
int main(void){int j=2003;/*(c)2003 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="g>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */

