From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: 2.5.56-mm1 fails to detect cd burner
Date: Mon, 17 Mar 2003 08:27:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3196100000.1047914843@aslan.scsiguy.com>
References: <20030311063627.GJ1399@holomorphy.com> <20030311160358.GN465@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030311160358.GN465@holomorphy.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-scsi@vger.kernel.org

> On Mon, Mar 10, 2003 at 10:36:27PM -0800, William Lee Irwin III wrote:
>>  scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA
>>  DRIVER, Rev 6.2.26
>>          <Adaptec 3960D Ultra160 SCSI adapter>
>>          aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
>>  
>>  (scsi0:A:0:0): Completed command without status.
>>  (scsi0:A:0:0): Protocol violation in Message-in phase.  Attempting to abort.
>>  (scsi0:A:0:0): Abort Message Sent
>>  (scsi0:A:0:0): SCB 3 - Abort Completed.
>>  scsi0:A:0:0: DV failed to configure device. Please file a bug report against this driver.
>> 
>> It's had other problems burning CD's in 2.5.x
> 
> jejb referred me to you (gibbs) for this after guiding me through a
> cable check.

Can you try the latest driver 6.2.30, from here:

http://people.FreeBSD.org/~gibbs/linux/SRC/

Just untar the 2.5.X tarball into your source tree and recompile.
If you still are having problems with the driver at that point, I'll
guide you through other steps to enable debugging and get additional
information.

--
Justin

