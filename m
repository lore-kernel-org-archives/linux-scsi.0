From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 20:58:36 +0100
Message-ID: <20060516195836.GA3807@infradead.org>
References: <4468B596.9090508@garzik.org> <1147789098.3505.19.camel@mulgrave.il.steeleye.com> <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com> <4469F906.7040602@gmail.com> <1147796999.3505.42.camel@mulgrave.il.steeleye.com> <446A0053.5070203@gmail.com> <1147798226.3505.56.camel@mulgrave.il.steeleye.com> <446A06C7.5050609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <446A06C7.5050609@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 17, 2006 at 02:07:19AM +0900, Tejun Heo wrote:
> > Yes, but in scsi_priv.h, please ... I can actually think of another use
> > for it in terms of getting the SG reset handler to work properly.
> 
> Okay, will do in scsi_priv.h

Things used by the transport classes traditionally weren't in scsi_priv.h,
that was for scsi_mod internals only.  Should we changed that?  I'd rather
have another header for semi-volatile APIs transport classes use.

