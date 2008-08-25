From: eerov@welho.com
Subject: RE: mptsas and mptbase sas problems on fujitsu-siemens rx200-s3
	rack server
Date: Mon, 25 Aug 2008 12:00:54 +0300
Message-ID: <20080825120054.6cpgvw8l4wkwcccs@webmail.welho.com>
References: <E7A31DABE7AC2D4C9BB5B343E834737802564215@enbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43941 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbYHYJAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2008 05:00:55 -0400
In-Reply-To: <E7A31DABE7AC2D4C9BB5B343E834737802564215@enbmail01.lsi.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Heusmann, Heino" <Heino.Heusmann@lsi.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, Eero Volotinen <eero.volotinen@iki.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Stewart, Ken" <Ken.Stewart@lsi.com>, "martin.wilck@fujitsu-siemens.com" <martin.wilck@fujitsu-siemens.com>

Quoting "Heusmann, Heino" <Heino.Heusmann@lsi.com>:

> Hello Eero,
> Please contact FSC for firmware update.
> The support and the firmware must come from FSC.
> Our standard FW from the Web won't work, because the FW has special   
> settings for each Board included.
>
> Best Regards
> Heino Heusmann
> LSI Storage FAE

I already updated to lastest firmware that is available from FSC,  
using serverview serverstart 7.804 version and latest mpt_sas driver  
from LSI logic support web.

Current firmware version is:

      Port Name         Chip Vendor/Type/Rev    MPT Rev  Firmware Rev
  1.  /proc/mpt/ioc0    LSI Logic SAS1068 B0      105      01122800

This problem still exists, it works a bit better, but I still get sometimes
many errors when disk i/o r/w load and system is unstable and very slow.

Errormessages look like this:

sd 0:1:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,  
sc=ffff81001aedb500, mf = ffff81007e811180, idx=1d3
sd 0:1:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,  
sc=ffff81007f4af680, mf = ffff81007e811280, idx=1d5
sd 0:1:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,  
sc=ffff81007f6d96c0, mf = ffff81007e812300, idx=1f6
sd 0:1:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,  
sc=ffff81001afbc540, mf = ffff81007e812380, idx=1f7
sd 0:1:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,  
sc=ffff81001ac6cb40, mf = ffff81007e812680, idx=1fd

with  2.6.16.60-0.21-smp #1 SMP Tue May 6 12:41:02 UTC 2008 x86_64  
x86_64 x86_64 GNU/Linux and

SUSE Linux Enterprise Server 10 (x86_64)
VERSION = 10
PATCHLEVEL = 2

--
Eero

