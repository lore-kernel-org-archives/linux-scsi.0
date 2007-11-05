From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [PATCH] zfcp: add some internal zfcp adapter statistics
Date: Mon, 5 Nov 2007 12:35:32 +0100
Message-ID: <200711051235.32482.swen@vnet.ibm.com>
References: <200710311133.52090.swen@vnet.ibm.com> <20071103091722.GA7807@osiris.boeblingen.de.ibm.com> <20071103094058.GA25134@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756028AbXKELfs@vger.kernel.org>
In-Reply-To: <20071103094058.GA25134@osiris.boeblingen.de.ibm.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, Linux on 390 Port <LINUX-390@vm.marist.edu>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Saturday 03 November 2007 10:40, Heiko Carstens wrote:
> > > +	if (!(adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA)) {
> > > +		ZFCP_LOG_NORMAL("error: Enhanced measurement feature not "
> > > +				"supported");
> > > +		return -EOPNOTSUPP;
> > > +	}
> 
> Btw. any user can flood the console with these messages if the adapter
> doesn't support the feature. That can be considered a denial of service
> attack. Please just return -EOPNOTSUPP and don't print anything on the
> console.
> 
I can see your point but I think you're a bit too extreme in your assessment on a simple console
message (with almost no processing behind it). If someone really wants to "flood" the console with messages they 
go other and possibly easier ways to achieve the same thing, how about "logger" !

But since it seems to bother you a lot, I will remove the message.

Cheers Swen
