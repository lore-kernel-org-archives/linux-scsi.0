From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] sd: Fix regression in sd_read_cache_type
Date: Wed, 23 Mar 2011 09:44:34 -0700 (PDT)
Message-ID: <529298.55791.qm@web31812.mail.mud.yahoo.com>
References: <Pine.LNX.4.44L0.1103231146460.2211-100000@iolanthe.rowland.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm12.bullet.mail.bf1.yahoo.com ([98.139.212.171]:20615 "HELO
	nm12.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752464Ab1CWQog convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 12:44:36 -0400
In-Reply-To: <Pine.LNX.4.44L0.1103231146460.2211-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>
Cc: Richard Senior <richard@r-senior.demon.co.uk>, SCSI development list <linux-scsi@vger.kernel.org>

--- On Wed, 3/23/11, Alan Stern <stern@rowland.harvard.edu> wrote:
>=20
> Reverting the original patch for now is fine with me.=A0

You mean my patch? This commit: 24d720b726c1a85f1962831ac30ad4d2ef8276b=
1.

> As for the next
> merge window, let me submit a more bullet-proof version of
> the second
> patch.

How can you submit a "more bullet-proof" version of the second patch wi=
thout the "first", which would be my topic patch I assume? This
one: 24d720b726c1a85f1962831ac30ad4d2ef8276b1.

Does this mean you'll resubmit my topic patch as your own and roll your=
 minor patch with it?

> It's possible that some wierd USB device will report that
> more than 192
> bytes of mode-sense data is available and then fail when
> the host asks
> for the reported amount.=A0 You'd think no device could
> be that stupid,

If by "fail" you mean "crash", then yes, that's bad. However, the devic=
e may return less data. The while loop of my patch, 24d720b726c1a85f196=
2831ac30ad4d2ef8276b1, will correctly parse the returned
less data.

> but I have seen an example of a device doing exactly this
> (except that
> it was for INQUIRY data rather than MODE SENSE data --
> which is perhaps
> even worse!).

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
