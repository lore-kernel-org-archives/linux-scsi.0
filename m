From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: 31 Oct 2002 19:21:12 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1036092072.8584.118.camel@irongate.swansea.linux.org.uk>
References: <Pine.BSF.4.21.0210311027500.23076-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.BSF.4.21.0210311027500.23076-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

On Thu, 2002-10-31 at 18:28, Matthew Jacob wrote:
> > 3) Linux should be using the Report Luns command to determine how
> >    many luns are on a device and at what locations.  This might
> >    even allow you to never probe more than 8 luns on a SCSI 2
> >    device unless they support this command.  Does the Symetrix support
> >    it?  Going beyond 8 luns on a SCSI2 device is really a hack
> >    otherwise.
> 
> Absolutely.

Now is the right time to fix this properly for 2.5

