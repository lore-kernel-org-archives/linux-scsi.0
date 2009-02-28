From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] : Spinning up disk is observed on standby paths
	until timeout, resulting in longer path restoration time.
Date: Sat, 28 Feb 2009 15:56:21 -0800
Message-ID: <1235865381.10562.0.camel@localhost.localdomain>
References: <DB8E544DD4B3D346A36F2698103530AE292A9BDC54@GVW1105EXC.americas.hpqcorp.net>
	 <1235144182.3349.5.camel@localhost.localdomain>
	 <20090220155221.GU16841@parisc-linux.org>
	 <1235145795.9025.4.camel@localhost.localdomain>
	 <20090220161334.GV16841@parisc-linux.org>
	 <1235147048.9025.9.camel@localhost.localdomain>
	 <20090220170431.GW16841@parisc-linux.org>
	 <DB8E544DD4B3D346A36F2698103530AE292ABB05C1@GVW1105EXC.americas.hpqcorp.net>
	 <1235400748.3361.9.camel@localhost.localdomain>
	 <20090228212625.GR16891@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38993 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbZB1X40 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2009 18:56:26 -0500
In-Reply-To: <20090228212625.GR16891@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Rengarajan, Narayanan (STSD)" <narayanan.rengarajan@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sat, 2009-02-28 at 14:26 -0700, Matthew Wilcox wrote:
> On Mon, Feb 23, 2009 at 08:52:28AM -0600, James Bottomley wrote:
> > On Mon, 2009-02-23 at 11:48 +0000, Rengarajan, Narayanan (STSD) wrote:
> > > If this patch is valid , when can we expect this on mainstream
> > > kernel . I can help testing this patch when included in the kernel.
> > 
> > If you could test it and report that it works, probably fairly
> > immediately.
> 
> Narayanan reported that the patch I sent worked, but it wasn't in the push
> to Linus you just sent.  I'm not quite sure whether 'fairly immediately'
> meant 'for 2.6.29' or 'for 2.6.30', so I don't know whether this was an
> oversight or an intentional omission.  In case it was the former, I'm
> alerting you to it ;-)

It was intentional ... I've been trying to incubate rc-fixes in the next
tree for a few days (which means I can't add to the rc-fixes tree after
about Monday if I want to send it to Linus on Friday/Saturday), so it
will be in the next push.

James


