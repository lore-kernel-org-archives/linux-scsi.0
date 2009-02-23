From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 1/1] : Spinning up disk is observed on standby paths
	until timeout, resulting in longer path restoration time.
Date: Mon, 23 Feb 2009 08:52:28 -0600
Message-ID: <1235400748.3361.9.camel@localhost.localdomain>
References: <DB8E544DD4B3D346A36F2698103530AE292A9BDC54@GVW1105EXC.americas.hpqcorp.net>
	 <1235144182.3349.5.camel@localhost.localdomain>
	 <20090220155221.GU16841@parisc-linux.org>
	 <1235145795.9025.4.camel@localhost.localdomain>
	 <20090220161334.GV16841@parisc-linux.org>
	 <1235147048.9025.9.camel@localhost.localdomain>
	 <20090220170431.GW16841@parisc-linux.org>
	 <DB8E544DD4B3D346A36F2698103530AE292ABB05C1@GVW1105EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35898 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752958AbZBWOwb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2009 09:52:31 -0500
In-Reply-To: <DB8E544DD4B3D346A36F2698103530AE292ABB05C1@GVW1105EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rengarajan, Narayanan (STSD)" <narayanan.rengarajan@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2009-02-23 at 11:48 +0000, Rengarajan, Narayanan (STSD) wrote:
> If this patch is valid , when can we expect this on mainstream
> kernel . I can help testing this patch when included in the kernel.

If you could test it and report that it works, probably fairly
immediately.

James


