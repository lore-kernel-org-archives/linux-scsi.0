From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET 00/18] open-osd: OSD Initiator library for Linux
Date: Sun, 09 Nov 2008 16:58:59 +0200
Message-ID: <4916FAB3.4010409@panasas.com>
References: <48876009.8010701@panasas.com>	<491073BB.4000900@panasas.com> <20081104111923.bb19c238.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20081104111923.bb19c238.akpm@linux-foundation.org>
Sender: linux-next-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com, linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, Sam Ravnborg <sam@ravnborg.org>
Cc: michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, Sami.Iren@seagate.com, Pete Wyckoff <pw@padd.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andrew Morton wrote:
> On Tue, 04 Nov 2008 18:09:31 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> Please consider for inclusion, an in-kernel OSD initiator
>> library. Its main users are planned to be various OSD based file
>> systems and the pNFS-Objects Layout Driver. (To be submitted soon)
>>  
>> To try out and run the library please visit
>> http://open-osd.org and follow the instructions there.
>>
>> The submitted patchset is also available via git at:
>>    git://git.open-osd.org/linux-open-osd.git osd
>>    http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=osd
>>
>> Or a compact out-of-tree repository that includes sources 
>> and some extras:
>>    git://git.open-osd.org/open-osd.git master
>>    http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary
>>
>> ...
>>
>> We would like this to sit in -mm tree for a while to make sure it is compilable
>> on all platform.
> 
> The best way to do that is to include your git tree in linux-next.  If
> this code has a probably-will-be-merged-in-2.6.29 status then please
> prepare a branch for Stephen to include in the linux-next lineup.
> 

Hi Stephen and James

I have prepared a branch for linux-next based on today's Linus tree
It is here:
    git://git.open-osd.org/linux-open-osd.git linux-next
This is if it's OK with James, as these bits are his responsibility.
They need only sit in linux-next for a couple of weeks to get some wider
compilation exposure. Other then that they are totally new code and
are safe. Eventually they should be included into Linux-next through
scsi-misc-2.6.

I have only posted "ver 2" updates to a couple of patches that had
comments by people but more patches changed. Mainly:
- rename of scsi_dev => scsi_device
- missing static keyword
- Kbuild fixes and comments by Sam Ravnborg
- small typos found on the way

The new patchset can be reviewed at:
    git://git.open-osd.org/linux-open-osd.git linux-next
    http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=linux-next

or Based on current scsi-misc-2.6:
    git://git.open-osd.org/linux-open-osd.git osd
    http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=osd

I did not want to spam the mailing-list with somewhat same patches.
I will post them, if any one needs me to.

Thanks everyone for your help
Boaz
