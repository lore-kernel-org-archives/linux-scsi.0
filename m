From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC][PATCH] Add a flight data recorder for scsi commands
Date: Wed, 28 Aug 2013 14:45:14 +0200
Message-ID: <521DF0DA.10004@acm.org>
References: <20130827220325.GB7293@logfs.org> <20130827221714.GC7293@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:39782 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab3H1MpR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 08:45:17 -0400
In-Reply-To: <20130827221714.GC7293@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-scsi@vger.kernel.org

On 08/28/13 00:17, J=F6rn Engel wrote:
> Here is a fun patch in an early state.  Essentially I want to trace
> scsi commands, which has already been done long ago.  The problem I
> have is that I care about all the scsi commands for one particular
> device - without knowing in advance which device it will be.  Once I
> know the device in question, I want to dump the last X commands.
>
> The existing tracing is covering all commands to all devices.  So
> either I have to oversize my trace buffer and dump way too much, or I
> will miss the stuff I am interested in most of the time.  Hence my
> per-device trace buffer (called fdr to avoid namespace collisions).

Isn't this facility something that overlaps with what Wireshark can=20
already do today ? Wireshark can already capture SCSI traces for severa=
l=20
transport types (iSCSI, USB, ...). For other transports, e.g. FC, I'd=20
prefer to see Wireshark being extended instead of adding more SCSI=20
tracing mechanisms in the SCSI core.

Best regards,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
