From: Steven Dake <sdake@mvista.com>
Subject: Re: Migrating RAID array to a different manufacturer controller
Date: Tue, 18 Feb 2003 11:05:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E5275DF.3090000@mvista.com>
References: <3E511791.2060904@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E511791.2060904@cri74.org>
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>, linux-scsi@vger.kernel.org

You have to use one driver to read the data from adaptor A and another 
driver to write the data to adaptor B after you have setup the RAID 
arrays on adaptor B to match that of adaptor A.  There is no homogenous 
way to access that data.  Dell had proposed a common superblock format, 
but that pretty much got shot down because it eases the ability of 
customers to switch vendors.

Thanks
-steve

Fabien Salvi wrote:

> Hello,
>
> Here is a question that is maybe a bit off topic.
> Sorry for that...
>
> Is it possible to migrate a RAID array from a manufacter controller to 
> another ?
> Is it depend on the level of RAID ?
> I've already be able to read data from RAID 1 because it's simple 
> mirroring (with Mylex DAC 960 controller).
> But, it may not be the case for all controllers I suppose...
>
> In fact, I have a server or a storage enclosure that use a CMD, 
> ICP-Vortex or Mylex controller and I would like to get data from it.
>
> Maybe it's possible with linux software RAID tools ?
>
> What can differentiate from a controller to another ?
> Maybe the parity block size ?
>
>
> Thanks in advance for your help !
>
> B.R.
>

