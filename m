From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: TMSCSIM [2.6] (cards)
Date: Fri, 28 Nov 2003 10:45:11 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC6A8A7.2050003@yk.rim.or.jp>
References: <Pine.LNX.4.44.0311272338560.12446-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pl576.nas911.n-yokohama.nttpc.ne.jp ([210.139.39.64]:53706 "EHLO
	standard.erephon") by vger.kernel.org with ESMTP id S261825AbTK1BpY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2003 20:45:24 -0500
Received: from (client is using the wrong hostname!) yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m1APXh5-00393vC@standard.erephon> (Debian Smail3.2.0.115)
	for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2003 10:45:15 +0900 (JST)
In-Reply-To: <Pine.LNX.4.44.0311272338560.12446-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

Guennadi Liakhovetski wrote:
> Hi
> 
> What are the best (for testing) tmscsim-supported cards (tekram (t) /
> dawicontrol / ...)? My on-board am53c974 is way too simple... Or does the
> probability of getting bugs depend of what devices hang on it?
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> 
> 
I have been using TEKRAM dc390 for some years with good result.

If I recall correctly, Kurt Garloff used dawicontrol card during
early debugging sessions with me on the driver.

I DO suspect that the different
devices on the bus may trigger different bugs.

Does someone use SCSI CDROM with DC390 as I do?
Maybe such person might want to test this driver under 2.6.0-testXX.


-- 
int main(void){int j=2003;/*(c)2003 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="g>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */

