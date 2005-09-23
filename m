From: Ric Wheeler <ric@emc.com>
Subject: Re: SATA Drive Information (vs hdparm -i)?
Date: Thu, 22 Sep 2005 21:33:52 -0400
Message-ID: <43335B80.5070308@emc.com>
References: <7744a2840509221206254d2109@mail.gmail.com>  <43334AFF.8010901@torque.net>  <Pine.LNX.4.58.0509221729480.6613@shark.he.net> <7744a28405092218012aa90cd0@mail.gmail.com> <43335755.501@emc.com> <Pine.LNX.4.58.0509221819350.6613@shark.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0509221819350.6613@shark.he.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Richard Bollinger <rabollinger@gmail.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Randy.Dunlap wrote:

>On Thu, 22 Sep 2005, Ric Wheeler wrote:
>
>  
>
>>Richard Bollinger wrote:
>>
>>    
>>
>>>I'm specifically looking for something that will reveal the serial
>>>number of each SATA drive.
>>>-
>>>
>>>      
>>>
>>hdparm (modified to run against libata SCSI drives) does show the serial
>>number:
>>
>>[root@c001n01 root]# hdparm -I /dev/sda
>>
>>/dev/sda:
>>
>>ATA device, with non-removable media
>>        Model Number:       Maxtor 6B300S0
>>        Serial Number:      B60J1DTH
>>        Firmware Revision:  BANC1B70
>>    
>>
>
>and where is that patch?...
>
>  
>
If you look at the hdparm homepage 
(http://freshmeat.net/projects/hdparm/)  you will see a thread on this - 
you need a kernel that supports libata passthru,

ric

