From: Mukul Kotwani <mkotwani@yahoo.com>
Subject: Re: Performance
Date: Fri, 2 Aug 2002 16:01:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020802230124.59457.qmail@web14007.mail.yahoo.com>
References: <20020802081655.B15152@hpti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020802081655.B15152@hpti.com>
List-Id: linux-scsi@vger.kernel.org
To: Craig Tierney <ctierney@hpti.com>
Cc: linux-scsi@vger.kernel.org

Running IOMeter against the Qlogic with IBM 15kRPM
JBODS, Im getting:

1) For 512 byte 100%random reads, I get *just* 260 
IOPs per sec.On Windows with IOMeter, I get about 7000
foir the same config.


2) For 512k 100%sequential reads, I see 30MB per sec.
Windows gives 85MB/sec

I see the similar performance with my driver on Linux.
I dont know whyit is so low, cannot be that low as
compared to windws, a few MB/sec or a few hundred IOPs
per sec difference is OK, but this difference is TOO
huge. I tried a bunch of diff host template params,
but doesnt seem to make a difference.

Has anyone dont any testing with IOMeter? Or is there
any other toold I can use to test IOPs/througput?


Thanks,
Mukul

--- Craig Tierney <ctierney@hpti.com> wrote:
> For the Qlogic 2200F I am able to push 100 MB/s for
> reads and writes using multiple threads to a
> filesystem
> that is striped across mutliple host ports on the
> SAN.  Backend RAID is a 
> Data Direct Networks SAN.  For a single thread to a
> ext3 filesystem
> and 2.4.18, I get about 70 MB/s for reads and
> writes.
> 
> I have no Iops/sec numbers.
> 
> Craig
> 
> 
> > Hello!
> > Does anyone have any performace numbers of a
> Qlogic
> > HBA? No of IOps/sec Max MBs /sec?
> > 
> > Thanks!
> > M
> > 
> > 
> > __________________________________________________
> > Do You Yahoo!?
> > Yahoo! Health - Feel better, live better
> > http://health.yahoo.com
> > -
> > To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Craig Tierney (ctierney@hpti.com)
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
http://vger.kernel.org/majordomo-info.html


__________________________________________________
Do You Yahoo!?
Yahoo! Health - Feel better, live better
http://health.yahoo.com
