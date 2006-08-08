From: olecom@mail.ru
Subject: =?koi8-r?Q?Re=3A_[sbp2]_external_hard_disk_shutdown_timer?=
Date: Tue, 08 Aug 2006 21:31:38 +0400
Message-ID: <E1GAVQY-0003ck-00.olecom-mail-ru@f41.mail.ru>
Reply-To: olecom@mail.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from f41.mail.ru ([194.67.57.79]:19467 "EHLO f41.mail.ru")
	by vger.kernel.org with ESMTP id S965012AbWHHRbk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2006 13:31:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Linux SCSI <linux-scsi@vger.kernel.org>

Date: Tue, 08 Aug 2006 11:27:12 -0400
Subject: Re: [sbp2] external hard disk shutdown timer
>
> Stefan Richter wrote:
> > Douglas Gilbert wrote:
> >> olecom@mail.ru wrote:
> >>> Hallo ! Let me ask a question.
> >>>
> >>> I couldn't change some values (f.e IDLE or ICT), while its
> >>> "changing" flag is "y".
> >> I would be surprised if you could change IDLE or
> >> ICT on a SCSI disk and even more surprised if
> >> that could be done through a bridge to an ATA
> >> disk (as is happening in your case).
>
> It seems that <olecom@mail.ru> hopes the the SCSI "idle"
> power condition will map to the ATA STANDBY command
> (as the ATA IDLE command action looks pretty vague).
>
I didn't hope on anything, actually, but wanted to find in t10's specs,
what i saw in sdparm output.

In "SCSI Primary Commands - 2 (SPC-2): 8.3.9 Power condition page"
<http://t10.org/ftp/t10/drafts/spc2/spc2r20.pdf> page 204
i've found that matched what i wanted: IDLE and STANDBY timers in 1Ah table.
It seemed OK to me with that i saw in sdparm.

Anyway thank you, guys, i wish you keep good work done well !

P.S.

Finally it was like "wake up, Neo" for me. Why i don't use "standard flow"
to do things ? I mean load wiXP, ask WD support ? From WD's FAQ:
,-
|- Question
| Do Western Digital external hard drives spin down after a certain amount
| of inactivity time? How can I disable this feature?
|- Answer
| The external hard drives listed below will spin down (enter into power saver mode)
| after 10 minutes of drive inactivity. Once the drive is accessed again, the drive
| will exit from the power saver mode and spin back up.
|
| Please Note: This is a permanent feature of the external hard drives and cannot
| be disabled.
`-
Finita.

So, Douglas, this one isn't for 24x7 at all. But i think 250GB just for backup isn't
good, thus 10 minutes is a very short time interval. So, i need something like
'dd count=1 </dev/ext-wd' every 9 minutes in cron :-)

--
-o--=O`C
 #oo'L O
<___=E M

