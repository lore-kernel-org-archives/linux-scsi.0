From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx broken in 2.5.53/54 ?
Date: Tue, 07 Jan 2003 21:23:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <703940000.1041999784@aslan.btc.adaptec.com>
References: <20030103101618.GB8582@in.ibm.com> <596830816.1041606846@aslan.scsiguy.com> <20030106073204.GA1875@in.ibm.com> <274040000.1041869813@aslan.scsiguy.com> <20030108024107.GA1127@louise.pinerecords.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030108024107.GA1127@louise.pinerecords.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Tomas Szepe <szepe@pinerecords.com>
Cc: dipankar@in.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>> [gibbs@scsiguy.com]
>> 
>> These reads are actually more expensive than just using PIO.  Neither of
>> these older drivers included a test to try and catch fishy behavior.
> 
> Justin, are you quite sure that these tests actually work?
> I too have just run into

See my recent post to the SCSI list.  The tests don't work on
certain older controllers that lack a feature I was using.  The
latest csets submitted to Linus correct this problem (as verified
on a dusty dual P-90 PCI/EISA box just added to our regression cluster).

--
Justin

