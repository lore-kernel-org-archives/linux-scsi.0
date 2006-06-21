From: "Philip R. Auld" <pauld@egenera.com>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 12:41:50 -0400
Message-ID: <20060621164150.GM31472@vienna.egenera.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:25782 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S932256AbWFUQoZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 12:44:25 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: dougg@torque.net, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org


Hi,

Rumor has it that on Wed, Jun 21, 2006 at 11:42:53AM -0400 Salyzyn, Mark said:
> What about:
> 
>     scsi 2:0:1:0: Device: DASD HP 18.2G ATLAS10K3_18_SCA HP05 ANSI ver:
> 02

Parsing this, (and the Matt's earlier version), there are 5 tokens
there in the middle for 4 fields. How does one know what the vendor
string is for example?

Commas maybe?

 scsi 2:0:1:0: Device: DASD, HP 18.2G, ATLAS10K3_18_SCA, HP05, ANSI ver: 02


Cheers,

Phil


> 
> Or is such SCSI nomenclature like DASD falling from grace?
> 
> Sincerely -- Mark Salyzyn
> 
> Douglas Gilbert writes:
> 
> > > Sample output:
> > >   Vendor: HP 18.2G  Model: ATLAS10K3_18_SCA  Rev: HP05
> > >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > > 
> > > becomes:
> > > 
> > > scsi 2:0:1:0: Device: HP 18.2G ATLAS10K3_18_SCA HP05 ANSI 
> > ver: 02               
> > 
> > The peripheral device type is useful information, especially
> > when it is other than "Direct Access".
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Philip R. Auld, Ph.D.  	        	       Egenera, Inc.    
Software Architect                            165 Forest St.
(508) 858-2628                            Marlboro, MA 01752
