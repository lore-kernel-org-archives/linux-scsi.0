From: Michael Clark <michael@metaparadigm.com>
Subject: Re: ANNOUNCE: saftemon - SCSI Enclosure monitor for linux
Date: Thu, 18 Apr 2002 12:43:55 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CBE4F0B.2010108@metaparadigm.com>
References: <71714C04806CD51193520090272892170452B66C@ausxmrr502.us.dell.com>	<3CBE1D51.9050300@metaparadigm.com>	<3CBE3B56.1020408@metaparadigm.com> <yq1elhdwt3i.fsf@austin.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <mkp@mkp.net>
Cc: Matt_Domsch@Dell.com, mjacob@feral.com, linux-scsi@vger.kernel.org

Martin K. Petersen wrote:

>>>>>>"Michael" == Michael Clark <michael@metaparadigm.com> writes:
>>>>>>
>
>Michael> The SES command set is supposedly documented in the SFF-8067
>Michael> specification developed by an X3 committee. I assume is
>Michael> different to SAF-TE and have removed the reference to it in
>Michael> the readme.
>
>Yes.  SES is the successor to SAF-TE.
>
>It's different in the sense that there's no SAF-TE processor device
>visible on the bus.  Instead devices on an SES-capable bus will have
>EnvServ set in the inquiry page.
>
>I have some sample code kicking around, if you're interested.  Also,
>the SES specs are official T10 ones (unlike SAF-TE).  You can download
>them off t10.org.
>

Thanks. Okay, i just had a quick look at the spec and yes, it's quite 
different to SAF-TE.

I don't have any SES devices to test on but I may think about 
abstracting saftemon to handle
more than one protocol for inquiring enclosures. The SES attributes 
match pretty closely although
SES is s superset of SAF-TE.

It probably makes sense to include SMART, SAF-TE and SES monitoring into 
s single
consistent package. I'm not using SMART as with most RAID controllers, 
you only see logical
devices and have no contact directly with the drives (unless you use 
SCSI passthrough APIs
althoug these are different from one RAID controller driver to the next).

~mc

