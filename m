From: Mukul Kotwani <mkotwani@yahoo.com>
Subject: Re: Performance
Date: Sun, 4 Aug 2002 00:39:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020804073922.39115.qmail@web14008.mail.yahoo.com>
References: <10208032327.ZM1350371@classic.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <10208032327.ZM1350371@classic.engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Cc: linux-scsi@vger.kernel.org

Thanks for the reply Jeremy!

Can you point me to the proper test which I can use to
test it? I think I have pretty good servers and
storage. What did u guys use..and was there any tuning
of the OS required?

For the IOPs, I guess it must have been the Windows
cache then, because ths storage used was the same in
both cases.

Mukul


--- Jeremy Higdon <jeremy@classic.engr.sgi.com> wrote:
> We've seen about 15000 IOPS from a 2200 and nearly
> 40000 from a 2310.
> With the proper test and proper hardware, you ought
> to see up to 102 MB/s
> on disk reads with a 2200 and 204 MB/s with the 2300
> (10^6 MB).
> 
> However, you may have trouble matching this in the
> Linux block layer.
> Perhaps if you try the sg driver with direct I/O . .
> . .
> 
> I question the 100% random results that you got from
> Windows.  100%
> random implies no cache hits, which would leave you
> with the raw
> IOPS that the drive can supply (260 sounds in the
> right ballpark).
> 
> It would be impossible for the drive to supply 7000
> IOPS in a
> random workload.  If you were supplying out of the
> drive cache or
> Windows cache, then 7000 seems more reasonable
> (though perhaps not
> a very interesting number).
> 
> jeremy
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
