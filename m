From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Fusion-MPT much faster as module
Date: Tue, 22 Mar 2005 08:31:20 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0503220813290.17195@diagnostix.dwd.de>
References: <Pine.LNX.4.61.0503081327560.28812@praktifix.dwd.de>
 <20050321152723.4b86dc3a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
In-Reply-To: <20050321152723.4b86dc3a.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Moore, Eric  Dean" <emoore@lsil.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 21 Mar 2005, Andrew Morton wrote:

> Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>>
>> Hello
>>
>> On a four CPU Opteron compiling the Fusion-MPT as module gives much better
>> performance when compiling it in, here some bonnie++ results:
>>
>> Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
>>                      -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
>> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
>> compiled in  15872M 38366 71  65602  22 18348   4 53276 84  57947   7 905.4   2
>> module       15872M 51246 96 204914  70 57236  14 59779 96 264171  33 923.0   2
>>
>> This happens with 2.6.10, 2.6.11 and 2.6.11-bk2. Controller is a
>> Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI.
>>
>> Why is there such a large difference?
>>
>
> Holger, this problem remains unresolved, does it not?  Have you done any
> more experimentation?
>
No. For now I just leave it as module.

> I must say that something funny seems to be happening here.  I have two
> MPT-based Dell machines, neither of which is using a modular driver:
>
>
> akpm:/usr/src/25> 0 hdparm -t /dev/sda
>
> /dev/sda:
> Timing buffered disk reads:  64 MB in  5.00 seconds = 12.80 MB/sec
>
Got the same result when compiled in, always between 12 and 13 MB/s. As
module it is approx. 75 MB/s.

Hope that LSI Logic will find the problem.

Another question I have is there a way in what SCSI mode (320, 160, etc)
Fusion-MPT is running? Could not find anything in proc or dmesg. Adaptec
has the following information in dmesg (and more in proc):

    (scsi1:A:0): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)

Or has the Fusion-MPT some other tool to show this information?

Holger
