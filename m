From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: Performance
Date: Sat, 3 Aug 2002 23:27:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10208032327.ZM1350371@classic.engr.sgi.com>
References: <Pine.LNX.4.44.0208031845190.3186-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Simon Trimmer <simon@urbanmyth.org>
        "Re: Performance" (Aug  3,  7:16pm)
List-Id: linux-scsi@vger.kernel.org
To: Simon Trimmer <simon@urbanmyth.org>, Mukul Kotwani <mkotwani@yahoo.com>
Cc: Craig Tierney <ctierney@hpti.com>, linux-scsi@vger.kernel.org

We've seen about 15000 IOPS from a 2200 and nearly 40000 from a 2310.
With the proper test and proper hardware, you ought to see up to 102 MB/s
on disk reads with a 2200 and 204 MB/s with the 2300 (10^6 MB).

However, you may have trouble matching this in the Linux block layer.
Perhaps if you try the sg driver with direct I/O . . . .

I question the 100% random results that you got from Windows.  100%
random implies no cache hits, which would leave you with the raw
IOPS that the drive can supply (260 sounds in the right ballpark).

It would be impossible for the drive to supply 7000 IOPS in a
random workload.  If you were supplying out of the drive cache or
Windows cache, then 7000 seems more reasonable (though perhaps not
a very interesting number).

jeremy
