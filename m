From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: Performance
Date: Fri, 2 Aug 2002 16:06:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0208021602570.14068-100000@dragon.pdx.osdl.net>
References: <20020802230124.59457.qmail@web14007.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020802230124.59457.qmail@web14007.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mukul Kotwani <mkotwani@yahoo.com>
Cc: Craig Tierney <ctierney@hpti.com>, linux-scsi@vger.kernel.org

On Fri, 2 Aug 2002, Mukul Kotwani wrote:

| Running IOMeter against the Qlogic with IBM 15kRPM
| JBODS, Im getting:
|
| 1) For 512 byte 100%random reads, I get *just* 260
| IOPs per sec.On Windows with IOMeter, I get about 7000
| foir the same config.
|
| 2) For 512k 100%sequential reads, I see 30MB per sec.
| Windows gives 85MB/sec
|
| I see the similar performance with my driver on Linux.
| I dont know whyit is so low, cannot be that low as
| compared to windws, a few MB/sec or a few hundred IOPs
| per sec difference is OK, but this difference is TOO
| huge. I tried a bunch of diff host template params,
| but doesnt seem to make a difference.
|
| Has anyone dont any testing with IOMeter? Or is there
| any other toold I can use to test IOPs/througput?

Hi,

I'm not familiar with people using iometer with Linux.
How does someone do that?
I thought that it was a Windows client app.

A few people do use pgmeter (an iometer clean-room
replacement) on Linux.  SGI and IBM presented a paper
at USENIX just a few weeks ago in which pgmeter was used.
(pgmeter.sf.net).

Also, iozone can measure IOs/second or throughput.
www.iozone.org

~Randy

| Thanks,
| Mukul
|
| --- Craig Tierney <ctierney@hpti.com> wrote:
| > For the Qlogic 2200F I am able to push 100 MB/s for
| > reads and writes using multiple threads to a
| > filesystem
| > that is striped across mutliple host ports on the
| > SAN.  Backend RAID is a
| > Data Direct Networks SAN.  For a single thread to a
| > ext3 filesystem
| > and 2.4.18, I get about 70 MB/s for reads and
| > writes.
| >
| > I have no Iops/sec numbers.
| >
| > Craig
| >
| >
| > > Hello!
| > > Does anyone have any performace numbers of a
| > Qlogic
| > > HBA? No of IOps/sec Max MBs /sec?
| > >
| > > Thanks!
| > > M
| > > __________________________________________________
| > --
| > Craig Tierney (ctierney@hpti.com)
| > -

-- 
~Randy

