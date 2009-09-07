From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 7 Sep 2009 17:26:56 -0600
Message-ID: <200909071726.56432.tfjellstrom@shaw.ca>
References: <4A950FA6.4020408@redhat.com> <20090907114442.GG18831@arachsys.com> <20090907165504.GJ31003@lifeintegrity.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090907165504.GJ31003@lifeintegrity.com>
Sender: linux-ide-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>l
List-Id: linux-scsi@vger.kernel.org

On Mon September 7 2009, Allan Wind wrote:
> On 2009-09-07T12:44:42, Chris Webb wrote:
> > Sorry for the late follow up to this thread, but I'm also seeing symptoms
> > that look identical to these and would be grateful for any advice. I
> > think I can reasonably rule out a single faulty drive, controller or
> > cabling set as I'm seeing it across a cluster of Supermicro machines with
> > six Seagate ST3750523AS SATA drives in each and the drive that times out
> > is apparently randomly distributed across the cluster. (Of course, since
> > the hardware is identical, it could still be a hardware design or
> > firmware problem.)
> 
> Seeing the same thing with a Supermicro motherboard and a pair WDC 2 TB
> drives.  Disabling NCQ does not resolve the issue, nor increasing
> the safe_mode_delay.  This is with 2.6.30.4.  This machine is
> sitting on its hand (i.e. no significant load).

I have the same issue with a single WD 2TB Green drive. Technically two, but 
it always only gets errors from the same drive, so I was assuming it was the 
drive. I only have to setup the raid0 array, and put some light load on it for 
the kernel to start complaining, and eventually it just kicks the drive 
completely with the following messages:

sd 3:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
end_request: I/O error, dev sdb, sector 202026972

The drive does work fine prior to the frozen timeout errors. And I was using 
it in windows (same raid0 config) just fine with no errors what so ever.

> 
> /Allan
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
