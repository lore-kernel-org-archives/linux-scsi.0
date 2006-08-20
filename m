From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5 throughputs
Date: Sun, 20 Aug 2006 04:37:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0608200436010.13206@p34.internal.lan>
References: <3a1eedb70608191046o7dd207bfp15f02e90b297b1a9@mail.gmail.com>
 <Pine.LNX.4.64.0608191400080.17678@p34.internal.lan>
 <3a1eedb70608191958u2a6af61er36e01ee7d233998a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-config-owner@vger.kernel.org>
In-Reply-To: <3a1eedb70608191958u2a6af61er36e01ee7d233998a@mail.gmail.com>
Sender: linux-config-owner@vger.kernel.org
To: jassduec@gmail.com
Cc: linux-admin@vger.kernel.org, linux-config@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Sat, 19 Aug 2006, jassduec@gmail.com wrote:

> Yeah, infact it is in a PCI-X slot @66Mhz.
>
> On 8/19/06, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> 
>> 
>> On Sat, 19 Aug 2006, jassduec@gmail.com wrote:
>> 
>> > Hi All,
>> >
>> > I have a storage system with 12 Maxtor 7200 rpm 250GB hard drives in
>> > RAID 5 configuration with one hot spare. Maxtor claims that each drive
>> > is capable of providing 56 MB/s sustained throughput. My host system
>> > is connected to it using 64bit ultra320 Adaptec SCSI card. The host
>> > system has 3.0 GHz pentium 4 (with HT) processor and 4 GB of RAM
>> > running linux kernel 2.6.9. I was wondering what order of "maximum"
>> > sequential read/write, random read/write throughput should i expect
>> > using them. I am using some of the benchmarking tools like Bonnie,
>> > Bonnie++, tiobench, dd, iometer etc. However the results from them
>> > have been very depressing. Theoretically i should be able to achieve a
>> > read sequential throughput close to min(10*56 = 560, 320) = 320 MB/s.
>> > However my results are no way close to it. I was wondering if anybody
>> > can give me some insight of what order of practical throughputs i
>> > should expect using linux and what other factors may be creating
>> > bottlenecks.
>> >
>> > TIA
>> > -
>> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> 
>> Is your 64bit ultra320 card in a 64bit PCI + 66MHZ slot?
>> 
>> If not, you will be limited to 133mb/s.
>> 
>> 
>

What speeds are you currently seeing, r/w?

Have you tried making a 3-drive raid5 and increasing it by 1 drive at a 
time to see if there is any difference in speed?

Justin.
