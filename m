From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] eeprom-93cx6: Add (read-only) support for 8-bit mode
Date: Mon, 24 Nov 2014 14:16:20 +0100
Message-ID: <54732FA4.1090603@suse.de>
References: <1416831074-24282-1-git-send-email-linux@rainbow-software.org> <1416831074-24282-2-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416831074-24282-2-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/24/2014 01:11 PM, Ondrej Zary wrote:
> Add read-only support for EEPROMs configured in 8-bit mode (ORG pin c=
onnected
> to GND).
> This will be used by wd719x driver.
>=20
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
