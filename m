From: Pedro Pla <pedropla@holidaymarketing.com>
Subject: Re: Problem with Gdt driver under smp?
Date: Wed, 06 Nov 2002 08:50:08 +0800
Sender: linux-smp-owner@vger.kernel.org
Message-ID: <3DC86740.3070804@holidaymarketing.com>
References: <3DC0EBB3.9030707@holidaymarketing.com> <20021031120257.GF23217@redhat.com> <3DC71BF8.80100@holidaymarketing.com> <20021105033435.GA16634@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-smp-owner@vger.kernel.org>
To: linux-scsi@vger.kernel.org, linux-smp@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Doug Ledford wrote:

 >On Tue, Nov 05, 2002 at 09:16:40AM +0800, Pedro Pla wrote:
 >
 >
 >>Doug Ledford wrote:
 >>
 >>
 >>>Sounds like typical bad RAM problems.  Run a memory test on your RAM.
 >>>
 >>>
 >>>
 >>>
 >>>
 >>I've run memory tests, and memtest86 v3 gives no errors at all after its
 >>most thorough testing, I did however find some problems when running a
 >>test on memtest86 v2.8, however that gave errors on 8 seperate simm
 >>cards running under two different dual p3 motherboards, I just find it
 >>strange that they would all fail, I thought it might be the motherboard
 >>then, but 2 motherboards failing?
 >>
 >>
 >>
 >
 >I've got a memory test shell script on my web site that runs under 
linux.
 >Do me a favor and see if it thinks your machine has bad RAM.
 >
 >
 >
Been running the script all day and still no errors yet, and yes, it
seems to have used up all the memory or so says a cat /proc/meminfo with
only a few megs free and no swap activated. This is under a no smp
compiled kernel, under an smp compiled kernel I think it could die while
ungzipping the first source directory.. yeah it's that bad, no "subtle"
problem, just an asap kernel oops or segmentation fault.. can't switch
to mp 1.1 from mp 1.4 on this motherboard either, or at least I haven't
found out how yet, it's an intel scb2, intel says nothing about how to
do so on their sites, and the bios has no such option... at least the
machine runs flawlessly all tests in non-smp mode which makes me think
it isn't hardware..



