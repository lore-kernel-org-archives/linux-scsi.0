From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Subject: Re: mptsas and mptbase sas problems on fujitsu-siemens rx200-s3	rack
 server
Date: Mon, 25 Aug 2008 11:10:58 +0200
Message-ID: <48B27722.5050406@fujitsu-siemens.com>
References: <E7A31DABE7AC2D4C9BB5B343E834737802564215@enbmail01.lsi.com> <20080825120054.6cpgvw8l4wkwcccs@webmail.welho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:64859 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbYHYJZa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 05:25:30 -0400
In-Reply-To: <20080825120054.6cpgvw8l4wkwcccs@webmail.welho.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "eerov@welho.com" <eerov@welho.com>
Cc: "Heusmann, Heino" <Heino.Heusmann@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, Eero Volotinen <eero.volotinen@iki.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Stewart, Ken" <Ken.Stewart@lsi.com>

Hi Eero,

> I already updated to lastest firmware that is available from FSC,
> using serverview serverstart 7.804 version and latest mpt_sas driver
> from LSI logic support web.

FSC only supports you the native SLES10 SP2 driver in this case. Are you 
saying that updating to the latest driver from LSI has improved the 
situation for you?

> Errormessages look like this:
> 
> sd 0:1:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,
> sc=ffff81001aedb500, mf = ffff81007e811180, idx=1d3
> sd 0:1:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,
> sc=ffff81007f4af680, mf = ffff81007e811280, idx=1d5
> sd 0:1:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,
> sc=ffff81007f6d96c0, mf = ffff81007e812300, idx=1f6
> sd 0:1:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,
> sc=ffff81001afbc540, mf = ffff81007e812380, idx=1f7
> sd 0:1:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,
> sc=ffff81001ac6cb40, mf = ffff81007e812680, idx=1fd

I have not seen this type of error message so far. Perhaps it is 
specific to the driver you are using. Eric, Heino - do these messages 
indicate HW timeouts or other HW-related problems?

Martin


-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20209
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
