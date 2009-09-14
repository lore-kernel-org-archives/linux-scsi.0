From: Tejun Heo <tj@kernel.org>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 14 Sep 2009 16:46:42 +0900
Message-ID: <4AADF4E2.9030407@kernel.org>
References: <4A950FA6.4020408@redhat.com> <20090907114442.GG18831@arachsys.com> <20090907165504.GJ31003@lifeintegrity.com> <200909071726.56432.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200909071726.56432.tfjellstrom@shaw.ca>
Sender: linux-ide-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

Thomas Fjellstrom wrote:
> I have the same issue with a single WD 2TB Green drive. Technically two, but 
> it always only gets errors from the same drive, so I was assuming it was the 
> drive. I only have to setup the raid0 array, and put some light load on it for 
> the kernel to start complaining, and eventually it just kicks the drive 
> completely with the following messages:
> 
> sd 3:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> end_request: I/O error, dev sdb, sector 202026972
> 
> The drive does work fine prior to the frozen timeout errors. And I was using 
> it in windows (same raid0 config) just fine with no errors what so ever.

Can you post full dmesg output?  The above doesn't tell much about ATA
side of things.

Thanks.

-- 
tejun
