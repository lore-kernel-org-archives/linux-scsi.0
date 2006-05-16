From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 16:28:55 -0500
Message-ID: <1147814935.3505.88.camel@mulgrave.il.steeleye.com>
References: <4468B596.9090508@garzik.org>
	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
	 <4469F2B2.703@garzik.org>
	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
	 <4469F906.7040602@gmail.com>
	 <1147796999.3505.42.camel@mulgrave.il.steeleye.com>
	 <446A0053.5070203@gmail.com>
	 <1147798226.3505.56.camel@mulgrave.il.steeleye.com>
	 <446A06C7.5050609@gmail.com>  <20060516195836.GA3807@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060516195836.GA3807@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2006-05-16 at 20:58 +0100, Christoph Hellwig wrote:
> Things used by the transport classes traditionally weren't in scsi_priv.h,
> that was for scsi_mod internals only.  Should we changed that?  I'd rather
> have another header for semi-volatile APIs transport classes use.

well ... OK we don't necessarily have a header for SCSI APIs exported
exclusively to transport classes.  how about
drivers/scsi/scsi_transport_api.h?

James


