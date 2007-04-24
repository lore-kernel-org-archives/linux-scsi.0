From: Olivier Galibert <galibert@pobox.com>
Subject: Re: [patch 1/7] libata: check for AN support
Date: Tue, 24 Apr 2007 12:23:04 +0200
Message-ID: <20070424102304.GA58841@dspnet.fr.eu.org>
References: <20070424074856.005152262@intel.com> <20070423165943.0cc67bc5.kristen.c.accardi@intel.com> <20070424090713.65657495@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754600AbXDXKXI@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070424090713.65657495@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

Sorry for replying to Alan's reply, I missed the original mail.

> > +#define ata_id_has_AN(id)	\
> > +	((id[76] && (~id[76])) & ((id)[78] & (1 << 5)))

(a && ~a) & (b & 32)

I don't think that does what you think it does, because at that point
it's a funny way to write 0 ((0 or 1) binary-and (0 or 32)).

I'm not even sure what it is you want.  If for the first part you
wanted (id[76] != 0x00 && id[76] != 0xff), please write just that,
thanks :-)

  OG.
