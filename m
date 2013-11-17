From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Sat, 16 Nov 2013 22:43:40 -0800
Message-ID: <1384670620.3614.24.camel@dabdike.int.hansenpartnership.com>
References: <527AF287.7020700@ubuntu.com>
		 <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>
		 <527BDA11.6060603@interlog.com> <527C0349.5010301@ubuntu.com>
	 <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>
	 <52883CE9.9040102@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52883CE9.9040102@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: dgilbert@interlog.com, todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2013-11-16 at 22:50 -0500, Phillip Susi wrote:
> On 11/16/2013 01:20 PM, James Bottomley wrote:
> > No disk does, neither SCSI nor ATA.  The error handler is not 
> > automatically activated for a not ready/initializing command
> > required because of multi-path.  We override the default behaviour
> > via allow_restart only for IBM vfc/vscsi and ATA disks.  With this
> > patch SCSI devices would no longer ever restart after suspend.
> 
> I don't follow.  A scsi disk returns a sense status saying it requires
> a START UNIT command when issued a command before being started.  This
> triggers the eh which notices that sense status and issues the
> command.

OK, so three people have now told you that's not how the code works.
Why don't you just read it?  because there's not really much point us
reading your patches until you do.

James


