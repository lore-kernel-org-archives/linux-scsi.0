From: Simon Trimmer <simon@urbanmyth.org>
Subject: Re: Performance
Date: Sat, 3 Aug 2002 19:16:05 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0208031845190.3186-100000@localhost.localdomain>
References: <20020802230124.59457.qmail@web14007.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020802230124.59457.qmail@web14007.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mukul Kotwani <mkotwani@yahoo.com>
Cc: Craig Tierney <ctierney@hpti.com>, linux-scsi@vger.kernel.org

Those numbers do seem rather poor, using Matt Jacob's linux qlogic driver as
an initiator I can easily get 18,000 ops/s on 230x series isp cards with a
userspace app. I don't have recent figures for isp 220x cards but around 7k
ops/s matches some old notes and given the right workload you can pretty much
max out the channel.

Most of the block io experts have steered clear of the thread, this might be
because a lot of performance measurement depends on the load generator, your
scsi targets, the workload actually presented to them, whether OS readahead /
request merging fires etc etc etc. It's not so clear cut and simple anymore
for a straight answer!

Chances are the qlogic isp cards have more than enough grunt for most people.
If not, they are probably doing something wrong or can afford multiport
variants! :)

-Simon
Simon Trimmer <simon@urbanmyth.org>


On Fri, 2 Aug 2002, Mukul Kotwani wrote:
> Running IOMeter against the Qlogic with IBM 15kRPM
> JBODS, Im getting:
>
> 1) For 512 byte 100%random reads, I get *just* 260
> IOPs per sec.On Windows with IOMeter, I get about 7000
> foir the same config.
>
>
> 2) For 512k 100%sequential reads, I see 30MB per sec.
> Windows gives 85MB/sec
>
> I see the similar performance with my driver on Linux.
> I dont know whyit is so low, cannot be that low as
> compared to windws, a few MB/sec or a few hundred IOPs
> per sec difference is OK, but this difference is TOO
> huge. I tried a bunch of diff host template params,
> but doesnt seem to make a difference.
>
> Has anyone dont any testing with IOMeter? Or is there
> any other toold I can use to test IOPs/througput?
>
>
> Thanks,
> Mukul
>
> --- Craig Tierney <ctierney@hpti.com> wrote:
> > For the Qlogic 2200F I am able to push 100 MB/s for
> > reads and writes using multiple threads to a
> > filesystem
> > that is striped across mutliple host ports on the
> > SAN.  Backend RAID is a
> > Data Direct Networks SAN.  For a single thread to a
> > ext3 filesystem
> > and 2.4.18, I get about 70 MB/s for reads and
> > writes.
> >
> > I have no Iops/sec numbers.
> >
> > Craig
> >
> >
> > > Hello!
> > > Does anyone have any performace numbers of a Qlogic
> > > HBA? No of IOps/sec Max MBs /sec?
> > >
> > > Thanks!
> > > M



