From: Andrew Brooks <arb@sat.dundee.ac.uk>
Subject: Re: Tagged overlapped commands
Date: Tue, 16 Dec 2014 10:23:25 +0000
Message-ID: <CAHOfOo1wGTLvhqtY6s4eCW0Ny+sboEFr8d5A7R1G91DaRRejFw@mail.gmail.com>
References: <CAHOfOo1WuW8MD=r1zEEfd+csNEWacQA4EYa95zhUn49MxbEEsA@mail.gmail.com>
 <1417709828.8998.7.camel@HansenPartnership.com> <CAHOfOo3D9iXmesTGq-tf397WucY95D7kqZ7rtKshWyzBa1U9ow@mail.gmail.com>
 <1418022178.21408.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65197 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaLPKXr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2014 05:23:47 -0500
Received: by mail-ie0-f169.google.com with SMTP id y20so12659325ier.0
        for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2014 02:23:46 -0800 (PST)
In-Reply-To: <1418022178.21408.5.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 8 December 2014 at 07:02, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The error message likely means that the tape device had more than one
> command outstanding at once (i.e. one command was sent while the current
> command was still pending).  It could also mean that a tag got re-used
> (same tag issued while command with that tag was outstanding) but for a
> tape I think the former is more likely.  Is the queue depth set to one
> for the device?
>
> /sys/class/scsi_device/<dev>/device/queue_depth
> you can (as root) echo a value in there to change the depth.

Sadly setting the queue depth to 1 didn't prevent the error message :-(
All other ideas and suggestions for debugging gratefully received!

st0: Sense Key : Aborted Command [current]
st0: Add. Sense: Tagged overlapped commands (task tag 0)
