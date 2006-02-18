From: =?iso-8859-1?B?SvxyZ2VuIEUu?= Fischer <fischer@linux-buechse.de>
Subject: Re: [Bugme-new] [Bug 6092] New: drivers/scsi/pcmcia/aha152x_stub.c: aha152x_resume(): variable used before set
Date: Sun, 19 Feb 2006 00:58:18 +0100
Message-ID: <20060218235818.GA7529@linux-buechse.de>
References: <200602180209.k1I29meW030162@fire-2.osdl.org> <20060217211049.4368ff20.akpm@osdl.org> <20060218221039.GA3912@linux-buechse.de> <20060218141423.7d741859.akpm@osdl.org> <20060218233151.GA1985@linux-buechse.de> <20060218154614.1d017fdb.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:30672 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S932361AbWBSAHN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Feb 2006 19:07:13 -0500
Content-Disposition: inline
In-Reply-To: <20060218154614.1d017fdb.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>

Hi Andrew,

On Sat, Feb 18, 2006 at 15:46:14 -0800, Andrew Morton wrote:
> So are you saying that with this patch, the driver works OK?

Exactly.  I tested using a scanner and a tape drive.


J=FCrgen
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
