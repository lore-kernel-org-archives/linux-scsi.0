From: Ishikawa <ishikawa@yk.rim.or.jp>
Subject: Re: [PATCH] kill scsihosts= boot parameter
Date: Sat, 07 Jun 2003 02:05:49 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE0C9ED.2D0EEE89@yk.rim.or.jp>
References: <20030606075954.GB18838@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pl051.nas911.n-yokohama.nttpc.ne.jp ([210.139.98.51]:24004 "EHLO
	standard.erephon") by vger.kernel.org with ESMTP id S262033AbTFFQwm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 12:52:42 -0400
Received: from yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m19OKfF-000H35C@standard.erephon> (Debian Smail3.2.0.114)
	for <linux-scsi@vger.kernel.org>; Sat, 7 Jun 2003 02:06:05 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>


RE scshihosts=driver1,driver2,driver3...

Are we really sure we want to remove this?
There non-disk devices, say,  CDROMs and tapes, which
can't be handled by fs label and
I had a feeling that the userland tools that looks
at the physical connecivity might not be
so well standardized (or made available on every major distribution.).

Am I wrong about the latter (userland tools)?

I am afraid
that I will have to tweak a few system administration scripts 
if this feature is gone.
(I don't know why this works on a PC I manage well.)

> This feature is seriously racy, and doesn't work under many
> circumstances.  As we have proper ways to find devices by their
> their locical naming (UUID, fs label) or physical connectivity
> (scsidev, sysfs) it shouldn't be nessecary anymore.
> 


-- 
int main(void){int j=2003;/*(c)2003 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="g>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */
