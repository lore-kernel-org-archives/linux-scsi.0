From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Possible performance regression?
Date: Tue, 03 Jan 2006 09:37:13 -0500
Message-ID: <43BA8C19.6010706@hp.com>
References: <43B94DB9.5040505@hp.com> <43BA5384.5070504@ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel9.hp.com ([156.153.255.214]:12217 "EHLO atlrel9.hp.com")
	by vger.kernel.org with ESMTP id S1751434AbWACObr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2006 09:31:47 -0500
In-Reply-To: <43BA5384.5070504@ilsb.tuwien.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Cc: linux-scsi@vger.kernel.org

Gerhard Schneider wrote:

>Alan D. Brunelle wrote:
>  
>
>>(0,1)         1      2      4      8     16     32     64    128    256
>>RHEL4U2    23.8   46.8   87.8   89.6   89.5   89.6   89.5   89.5   89.5
>>2.6.14      3.9    7.8   15.6   31.2   62.5   89.6   89.5   89.5   89.6
>>Differ    -83.6% -83.3% -82.2% -65.2% -30.2%   0.0%   0.0%   0.0%   0.0%
>>
>>(0,1) means target 1 on bus 0, and then the columns represent different
>>transfer sizes (1K up to 256K).  I also see some that show little if any
>>difference:
>>
>>(6,4)         1      2      4      8     16     32     64    128    256
>>RHEL4U2    23.9   46.9   88.5   90.0   89.9   89.9   89.9   90.0   89.9
>>2.6.14.2   24.1   47.0   88.5   90.0   89.9   90.0   89.9   89.9   89.9
>>Differ      0.8%   0.2%   0.0%   0.0%   0.0%   0.1%   0.0%  -0.1%   0.0%
>>
>>    
>>
>
>Did you apply [PATCH] mptfusion : dv performance fix by
>Eric Dean Moore? (Dec. 1st, 2005) W/o that patch the first four disks of
>an 1030 are performing 3.5 MB/s instead of 70 :-)
>It was funny how slow a RAID 5-0 can be when four of fourteen disks
>are slow...
>
>                                          GS
>
>  
>
I do not know how to grab that specific patch, but I am just trying a 
2.6.15-rc6 kernel, and things seem much better. I'm hoping that 
2.6.15-rc6 contains the patch you mention?

Thanks,
Alan
