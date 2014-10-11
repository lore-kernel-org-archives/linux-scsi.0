From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Date: Sat, 11 Oct 2014 10:41:53 -0700
Message-ID: <1413049313.2068.48.camel@jarvis.lan>
References: <20141010074901.GA32028@sucs.org>
 <20141011173902.GA1946@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20141011173902.GA1946@infradead.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, devel@linuxdriverproject.org, Christoph Hellwig <hch@lst.de>, Sitsofe Wheeler <sitsofe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2014-10-11 at 10:39 -0700, Christoph Hellwig wrote:
> On Fri, Oct 10, 2014 at 08:49:01AM +0100, Sitsofe Wheeler wrote:
> > Microsoft Hyper-V virtual disks currently only claim SPC-2 compliance
> > even though they implement post SPC-2 features (such as thin
> > provisioning) which means the Linux kernel does not go on to test for
> > those features even though they are advertised.
> > 
> > A previous patch attempted to add a quirk to workaround this but the
> > quirk was only enabled after the features had been scanned for, wouldn't
> > work for "small" disks and would quirk on  all Hyper-V SCSI devices
> > (e.g. passthrough disks).
> > 
> > The new patches partially revert the previous effort, add the quirk in a
> > more traditional manner to only Hyper-V virtual disks and work on small
> > virtual disks.
> 
> This seems like might want a quirk to simply "force" a SPC3 compliance
> level?

This was initially suggested, but rejected by Microsoft because of other
problems advertising SPC-3 compliance brings.  Perhaps the hyper-v
emulator has matured sufficiently that it will now work OK?

James
