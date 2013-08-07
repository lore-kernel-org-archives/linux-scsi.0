From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 3/8] [SCSI] dc395x: use NULL instead of 0
Date: Wed, 07 Aug 2013 08:50:03 +0200
Message-ID: <1375858203.1359.1.camel@linux-fkkt.site>
References: <001301ce9321$f2157760$d6406620$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:43130 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab3HGGvP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 02:51:15 -0400
In-Reply-To: <001301ce9321$f2157760$d6406620$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jingoo Han <jg1.han@samsung.com>
Cc: 'James Bottomley' <JBottomley@Parallels.com>, 'Ali Akcaagac' <aliakc@web.de>, 'Jamie Lenehan' <lenehan@twibble.org>, dc395x@twibble.org, 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org

On Wed, 2013-08-07 at 12:55 +0900, Jingoo Han wrote:

> @@ -4183,15 +4183,17 @@ static void check_eeprom(struct NvRamType *eeprom, unsigned long io_port)
>  		 */
>  		dprintkl(KERN_WARNING,
>  			"EEProm checksum error: using default values and options.\n");
> -		eeprom->sub_vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
> +		eeprom->sub_vendor_id[0] = (u8)(PCI_VENDOR_ID_TEKRAM & 0xff);

Hi,

if you are fixing these issues please use the proper macros for
conversion of endianness.

	Regards
		Oliver


