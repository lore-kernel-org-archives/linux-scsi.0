From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Firmware patches for SCSI
Date: Fri, 19 Dec 2008 15:29:03 -0500
Message-ID: <1229718543.18778.4.camel@localhost.localdomain>
References: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au, linux-next@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2008-12-20 at 01:23 +0530, Jaswinder Singh wrote:
> Hello all,
> 
> These SCSI's firmware patches are floating in linux-next from long time :
> 
> 1. qla1280: use request_firmware
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=7c84df1aec1bbb4e43ac9e2ba65b137042279a8d
> 2. advansys: use request_firmware
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=baca2b168d3b7340eac87414c046f7d49de4bf71
> 3. qlogicpti: use request_firmware
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=2c68b5b6db13786a425accc8576217b120f885f2
> 
> Should I need to resend these patches to merge main-stream.

Um ... depends how they got into linux-next.  The head commit just says

Merge commit 'firmware/master'

Which isn't very descriptive of where it came from.  It looks like
either a tree that linux-next shouldn't pull (or one the owner forgot to
push to linus).

James
