From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: aic7xxx: SCSI Bus Reset
Date: Tue, 24 Dec 2002 20:15:36 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0212242014310.3657-100000@uplift.swm.pp.se>
References: <2149895408.1040745297@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <2149895408.1040745297@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Shanker Balan <shanu@exocore.com>, Linux SCSI <linux-scsi@vger.kernel.org>

On Tue, 24 Dec 2002, Justin T. Gibbs wrote:

> > QUANTUM  Model: ATLAS10K3_18_SCA
> > QUANTUM  Model: ATLAS10K3_73_SCA
> > QUANTUM  Model: ATLAS10K3_73_SCA
> 
> Can you provide the firmware revisions of these drives.  Anything
> less than B440 is suspect.  The behavior your report looks like
> the drives stop returning queued I/O.  I have seen this before on
> at least B120, although it was when running at U320/packetized and
> not U160.  My guess is that the bug in these early firmware revs
> is protocol agnostic.

Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: QUANTUM  Model: ATLAS10K3_36_SCA Rev: 120G
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: QUANTUM  Model: ATLAS10K3_36_SCA Rev: 120G
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: QUANTUM  Model: ATLAS10K3_73_SCA Rev: 120G
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 04 Lun: 00
  Vendor: QUANTUM  Model: ATLAS10K3_73_SCA Rev: 120G
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 05 Lun: 00
  Vendor: QUANTUM  Model: ATLAS10K3_73_SCA Rev: 120G
  Type:   Direct-Access                    ANSI SCSI revision: 03

So I guess I should upgrade my firmware? It's the drive id 3 and 4 I have
had problems with so far.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

