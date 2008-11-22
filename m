From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: RE: Question regarding SAS controllers.
Date: Sat, 22 Nov 2008 16:59:28 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811221658280.707@p34.internal.lan>
References: <660360F4F2570145BD872F298951B17A5CC40737@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:51713 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbYKVV73 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2008 16:59:29 -0500
In-Reply-To: <660360F4F2570145BD872F298951B17A5CC40737@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>



On Sat, 22 Nov 2008, Moore, Eric wrote:

> On Saturday, November 22, 2008 2:47 PM, Justin Piszcz wrote:
>
>> Do any SAS controllers exist that are not RAID?
>>
>> Or to put it another way, if one wants to use SAS disks for
>> example and
>> NOT export them as JBOD or use them as RAID, is there a
>> normal controller?
>>
>> Back in the days of regular SCSI you had SCSI controllers and
>> SCSI raid
>> controllers, when searching for SAS controllers now, all that
>> comes up is
>> hundreds of SAS-Raid controllers.
>>
>
> mptsas
>
> http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/index.html
>
> Eric Moore
>

Eric,

Thanks, I had checked this out earlier but the only non-raid SAS HBAs 
(those HBAs that do not end in -R) that are JBOD seem to be external only
(e.g., do not contain any internal SAS ports?)

Justin.
