From: Phil Stracchino <alaric@babcom.com>
Subject: Re: [linux-usb-devel] Feiya 5-in-1 Card Reader
Date: Thu, 5 Sep 2002 11:00:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020905150026.GA4676@babylon5.babcom.com>
References: <UTC200209050841.g858fmZ28242.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <UTC200209050841.g858fmZ28242.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

On Thu, Sep 05, 2002 at 10:41:48AM +0200, Andries.Brouwer@cwi.nl wrote:
> > Speaking of sddr09 devices (of which I possess one), what's the current
> > state of support for the sddr09?  Last I knew, at the time when I finally
> > got mine working, the sddr09 was only supported read-only
> 
> For me it works read-write and out-of-the-box on a vanilla kernel.
> (I added this stuff a few months ago. Found in 2.5 (which I use).
> Am not quite sure about 2.4.)


Hmm.  So if I was to grab 2.5.${LATEST} and try porting the sddr09
driver back to 2.4.${CURRENT} ....

Thanks for the pointer.


-- 
  *********  Fight Back!  It may not be just YOUR life at risk.  *********
  phil stracchino   ::   alaric@babcom.com   ::   halmayne@sourceforge.net
    unix ronin     ::::   renaissance man   ::::   mystic zen biker geek
     2000 CBR929RR, 1991 VFR750F3 (foully murdered), 1986 VF500F (sold)
       Linux Now! ...because friends don't let friends use Microsoft.
