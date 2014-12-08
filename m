From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Tagged overlapped commands
Date: Sun, 07 Dec 2014 23:02:58 -0800
Message-ID: <1418022178.21408.5.camel@HansenPartnership.com>
References: <CAHOfOo1WuW8MD=r1zEEfd+csNEWacQA4EYa95zhUn49MxbEEsA@mail.gmail.com>
	 <1417709828.8998.7.camel@HansenPartnership.com>
	 <CAHOfOo3D9iXmesTGq-tf397WucY95D7kqZ7rtKshWyzBa1U9ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60176 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753941AbaLHHDA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2014 02:03:00 -0500
In-Reply-To: <CAHOfOo3D9iXmesTGq-tf397WucY95D7kqZ7rtKshWyzBa1U9ow@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Brooks <arb@sat.dundee.ac.uk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Adding linux-scsi back to cc.  Please don't drop because others may be
interested and it allows search engines to find the answer.

On Fri, 2014-12-05 at 13:09 +0000, Andrew Brooks wrote:
> On 4 December 2014 at 16:17, James Bottomley <
> James.Bottomley@hansenpartnership.com> wrote:
> 
> > The error message likely means that the tape device had more than one
> > command outstanding at once (i.e. one command was sent while the current
> > command was still pending).  It could also mean that a tag got re-used
> > (same tag issued while command with that tag was outstanding) but for a
> > tape I think the former is more likely.  Is the queue depth set to one
> > for the device?
> >
> 
> Thanks for your reply, How can I configure the queue depth?

it should be under

/sys/class/scsi_device/<dev>/device/queue_depth

you can (as root) echo a value in there to change the depth.

James


