From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [ANNOUNCE] MPT Fusion driver 3.01.10 update
Date: Tue, 6 Jul 2004 13:03:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704ABF284@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:476 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264183AbUGFREd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2004 13:04:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, hch@lst.de, hch@infradead.org

This is repost of 3.01.10 mpt fusion patch for lk2.6.  

This contains an additional patch from Christoph Hellwig:
- remove CONFIG_LBD ifdefs from fusion { mptscsih.c}

The patch for lk 2.6.7-bk series and the driver is available at
ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-patches/3.01.10

 
> All,
> 
> We are pleased to announce the MPT Fusion release candidate for lk 2.6
> 
> This driver incorporates the patches from Christoph Hellwig
> and Masao Fukuchi.
> 
> Changelog of this release:
> 
> * Patch provided by  Masao Fukuchi [fukuchi.masao@jp.fujitsu.com]
>  - mptctl updates for hot plug
> 
> * Patch provided by Christoph Hellwig [hch@infradead.org]
>  - mptlan updates for hot plug
> 
> 


Eric Moore
Standard Storage Products Division
LSI Logic Corporation

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
