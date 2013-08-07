From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 3/8] [SCSI] dc395x: use NULL instead of 0
Date: Wed, 07 Aug 2013 15:58:58 +0900
Message-ID: <002f01ce933b$96ebc370$c4c34a50$@samsung.com>
References: <001301ce9321$f2157760$d6406620$@samsung.com>
 <1375858203.1359.1.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:17760 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab3HGG7A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 02:59:00 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR500MQ6FEAEE40@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Wed, 07 Aug 2013 15:58:58 +0900 (KST)
In-reply-to: <1375858203.1359.1.camel@linux-fkkt.site>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Oliver Neukum' <oliver@neukum.org>
Cc: 'James Bottomley' <JBottomley@Parallels.com>, 'Ali Akcaagac' <aliakc@web.de>, 'Jamie Lenehan' <lenehan@twibble.org>, dc395x@twibble.org, 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>

On Wednesday, August 07, 2013 3:50 PM, Oliver Neukum wrote:
> On Wed, 2013-08-07 at 12:55 +0900, Jingoo Han wrote:
> 
> > @@ -4183,15 +4183,17 @@ static void check_eeprom(struct NvRamType *eeprom, unsigned long io_port)
> >  		 */
> >  		dprintkl(KERN_WARNING,
> >  			"EEProm checksum error: using default values and options.\n");
> > -		eeprom->sub_vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
> > +		eeprom->sub_vendor_id[0] = (u8)(PCI_VENDOR_ID_TEKRAM & 0xff);
> 
> Hi,
> 
> if you are fixing these issues please use the proper macros for
> conversion of endianness.

Sorry, I cannot understand exactly what you mean. :(
Would you please let me know which macros can be used?

Best regards,
Jingoo Han


