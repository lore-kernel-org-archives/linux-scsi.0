From: eerov@welho.com
Subject: Re: mptsas and mptbase sas problems on fujitsu-siemens rx200-s3
	rack server
Date: Mon, 25 Aug 2008 12:41:31 +0300
Message-ID: <20080825124131.ary0akau04wwk80g@webmail.welho.com>
References: <E7A31DABE7AC2D4C9BB5B343E834737802564215@enbmail01.lsi.com>
	<20080825120054.6cpgvw8l4wkwcccs@webmail.welho.com>
	<48B27722.5050406@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59892 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbYHYJld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2008 05:41:33 -0400
In-Reply-To: <48B27722.5050406@fujitsu-siemens.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: "Heusmann, Heino" <Heino.Heusmann@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, Eero Volotinen <eero.volotinen@iki.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Stewart, Ken" <Ken.Stewart@lsi.com>

Quoting Martin Wilck <martin.wilck@fujitsu-siemens.com>:

> Hi Eero,
>
>> I already updated to lastest firmware that is available from FSC,
>> using serverview serverstart 7.804 version and latest mpt_sas driver
>> from LSI logic support web.
>
> FSC only supports you the native SLES10 SP2 driver in this case. Are
> you saying that updating to the latest driver from LSI has improved the
> situation for you?

Yes, on native SLES 10 sp2 driver, the internal sas raid (mirror 1) is  
almost nonworking. Driver from LSI logic webpage works better, but it  
is far away from usable.

SAS array almost hangs the machine, if I try to copy 1.6GB file from  
network to internal sas raid. It works fine if I copy file to external  
Fibrechannel card
in the same machine.

The motherboard is already replaced once because the machine covered  
by warranty.

I am bit lost with this issue, because I am running supported driver  
on supported hardware, but still no work. I am thinking to install  
raid controller
on internal pci array and replace internal sas with that.

--
Eero

