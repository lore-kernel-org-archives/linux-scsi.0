From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 11:42:53 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:56556 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1751208AbWFUPmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2006 11:42:54 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

What about:

    scsi 2:0:1:0: Device: DASD HP 18.2G ATLAS10K3_18_SCA HP05 ANSI ver:
02

Or is such SCSI nomenclature like DASD falling from grace?

Sincerely -- Mark Salyzyn

Douglas Gilbert writes:

> > Sample output:
> >   Vendor: HP 18.2G  Model: ATLAS10K3_18_SCA  Rev: HP05
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > 
> > becomes:
> > 
> > scsi 2:0:1:0: Device: HP 18.2G ATLAS10K3_18_SCA HP05 ANSI 
> ver: 02               
> 
> The peripheral device type is useful information, especially
> when it is other than "Direct Access".
