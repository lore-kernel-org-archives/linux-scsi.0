From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: end to end error recovery musings
Date: Thu, 01 Mar 2007 09:19:39 -0800
Message-ID: <45E70B2B.9050401@zytor.com>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>	 <yq14pp78rze.fsf@sermon.lab.mkp.net>	 <20070227190236.58323a40@lxorguk.ukuu.org.uk>	 <yq1r6sb7733.fsf@sermon.lab.mkp.net>	 <20070227233946.7ad33a50@lxorguk.ukuu.org.uk>	 <yq1mz2z6wov.fsf@sermon.lab.mkp.net> <45E587C2.5010209@torque.net>	 <yq1zm6y42z0.fsf@sermon.lab.mkp.net>	 <1172683822.3374.13.camel@mulgrave.il.steeleye.com>	 <yq1hct641s0.fsf@sermon.lab.mkp.net>	 <1172685161.3374.18.camel@mulgrave.il.steeleye.com>	 <45E62C3C.5090906@zytor.com> <1172759123.3624.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1172759123.3624.3.camel@mulgrave.il.steeleye.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, dougg@torque.net, Alan <alan@lxorguk.ukuu.org.uk>, "Moore, Eric" <Eric.Moore@lsi.com>, ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2007-02-28 at 17:28 -0800, H. Peter Anvin wrote:
>> James Bottomley wrote:
>>> On Wed, 2007-02-28 at 12:42 -0500, Martin K. Petersen wrote:
>>>> 4104.  It's 8 bytes per hardware sector.  At least for T10...
>>> Er ... that won't look good to the 512 ATA compatibility remapping ...
>>>
>> Well, in that case you'd only see 8x512 data bytes, no metadata...
> 
> i.e. no support for block guard in the 512 byte sector emulation
> mode ...
> 

That makes sense, though... if the raw sector size is 4096 bytes, that 
metadata would presumably not exist on a per-sector basis.

	-hpa
