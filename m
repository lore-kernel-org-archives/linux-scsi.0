From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx: SCSI Bus Reset
Date: Tue, 24 Dec 2002 08:54:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2149895408.1040745297@aslan.scsiguy.com>
References: <20021224112158.GA667@exocore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021224112158.GA667@exocore.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Shanker Balan <shanu@exocore.com>, Linux SCSI <linux-scsi@vger.kernel.org>

> Hello:
> 
> I am experience aic7xxx SCSI reset errors which happens every so often
> on my NFS server:
> 
> Hardware:
> 
> Gigabyte GA-7DPXDw Dual SMP Motherboard with 512MB of RAM
> 2 AMD Athlon 1900
> Adaptec AIC-7892A U160/m (rev 02)
> QUANTUM  Model: ATLAS10K3_18_SCA
> QUANTUM  Model: ATLAS10K3_73_SCA
> QUANTUM  Model: ATLAS10K3_73_SCA

Can you provide the firmware revisions of these drives.  Anything
less than B440 is suspect.  The behavior your report looks like
the drives stop returning queued I/O.  I have seen this before on
at least B120, although it was when running at U320/packetized and
not U160.  My guess is that the bug in these early firmware revs
is protocol agnostic.

--
Justin

