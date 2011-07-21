From: Ingo Molnar <mingo@elte.hu>
Subject: Re: CONFIG_INTR_REMAP and CONFIG_DMAR dependencies?
Date: Thu, 21 Jul 2011 11:10:25 +0200
Message-ID: <20110721091024.GL9216@elte.hu>
References: <20110718211620.GD4770@plapp.qlogic.org>
 <CAE9FiQUgbvC6TiSXK-5K9bOsxYeCePoRoU-NBvtitweVBegyEA@mail.gmail.com>
 <CAE9FiQVUA2bWycDNmKDysPV6SQ1tcniJHUvbSDXpufC75cFVjg@mail.gmail.com>
 <20110718235030.GD11738@plapp.qlogic.org>
 <CAE9FiQUAJkiK-QYgaWy_NYeW81c0dA1_q3mw5mVX_AETNeKWww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQUAJkiK-QYgaWy_NYeW81c0dA1_q3mw5mVX_AETNeKWww@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, "Barnes, Jesse" <jesse.barnes@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, linux scsi dev <linux-scsi@vger.kernel.org>, linux pci <linux-pci@vger.kernel.org>, "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>, "hpa@linux.intel.com" <hpa@linux.intel.com>, Avik Shau <avik.shau@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> > Let me know if there's something else you need from our side. =A0Ho=
pe
> > this patch makes 3.0.
>=20
> Not sure. should be for 3.1 instead.

Yes - the bug was introduced in 2009 and the 3.0 will be later today.

Also, the fix should be done in a (much) cleaner fashion,=20
restructuring the whole DMAR mess if needed.

Thanks,

	Ingo
