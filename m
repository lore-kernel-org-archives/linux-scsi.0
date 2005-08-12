From: David Greaves <david@dgreaves.com>
Subject: Re: SATA status report updated
Date: Fri, 12 Aug 2005 19:07:58 +0100
Message-ID: <42FCE57E.2070302@dgreaves.com>
References: <42FC2EF8.7030404@pobox.com> <20050812074012.60487882.robn@berrymount.nl> <42FC375C.3040304@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s2.ukfsn.org ([217.158.120.143]:44682 "EHLO mail.ukfsn.org")
	by vger.kernel.org with ESMTP id S1750868AbVHLS0M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 14:26:12 -0400
In-Reply-To: <42FC375C.3040304@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Rob van Nieuwkerk <robn@berrymount.nl>, Linux IDE Mailing List <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:

>
> True enough :/
>
> It's been feature-complete for a while, but the reports from testers
> in the field have made me too nervous to push it into the upstream
> kernel.
>
> I might push it upstream, but disable it by default, which would allow
> for a wider test audience.

Could you specify what tests and reports would be useful and what risks
are involved?
Eg If I have 2 SATA drives then could (OK, of course it *could* - but is
it likely) I break sda whilst testing with sdb? I can live with crashes
and hangs and I can mitigate data loss, but I may think twice if it'll
toast the drive.

Nb: I often think that if people bemoaning the lack of testers put a bit
of effort into saying what tests would be useful then more people would
run them.
"Here run this and just say if it crashes" is one approach.
"Try these options, use smartd, turn on debugging like this and send
this part of the output if you have a problem. Previously reported
problems include: <blah, blah blah>. Oh, it's only ever going to affect
the drive you specify and the worst case scenario is a low-level format
using the vendor's download (which may or may not be available)" - makes
me more aware of what I'm getting into.

David

-- 

