From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: -test4 detects scsi hdds in another order than -test2 does
Date: Sat, 30 Aug 2003 13:51:28 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F502D50.9030800@yk.rim.or.jp>
References: <m33cfm19ar.fsf@bzzz.home.net> <3F4E4605.6040706@wmich.edu> <m3vfshrola.fsf@bzzz.home.net> <3F4F7129.1050506@wmich.edu> <m3vfsgpj8b.fsf@bzzz.home.net> <20030829091135.559a121f.akpm@osdl.org> <m3d6eopfvt.fsf_-_@bzzz.home.net> <20030829180628.GB22294@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pl637.nas911.n-yokohama.nttpc.ne.jp ([210.139.39.125]:3275 "EHLO
	standard.erephon") by vger.kernel.org with ESMTP id S261269AbTH3EsS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Aug 2003 00:48:18 -0400
Received: from yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m19sxi0-000H2sC@standard.erephon> (Debian Smail3.2.0.114)
	for <linux-scsi@vger.kernel.org>; Sat, 30 Aug 2003 13:51:32 +0900 (JST)
In-Reply-To: <20030829180628.GB22294@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Alex Tomas <bzzz@tmi.comex.ru>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org


> I assumed everyone who used scsi on Linux was used to the cards appearing
> in random order ...
> 

Well, not quite.

After all, the clever hacks like scsi adaptor scan order
boot option, scsihosts=...,  were invented to bring order to the chaos.

The following is my boot command for 2.4.21 kernel.
I folded the long line manually.

c:\loadlin\loadlin c:\loadlin\lin2421 -noheap  mem=nopentium devfs=mount \
  drm=debug root=/dev/sda6 ro vga=3 scsihosts=sym53c8xx:tmscsim



-- 
int main(void){int j=2003;/*(c)2003 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="g>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */

