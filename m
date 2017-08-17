From: Tejun Heo <tj@kernel.org>
Subject: Re: No I/O errors reported after SATA link hard reset
Date: Thu, 17 Aug 2017 06:25:19 -0700
Message-ID: <20170817132519.GD3238792@devbig577.frc2.facebook.com>
References: <fe5cc200a4cba71cb9e5e6a980699805@assyoma.it>
 <13561110-4e59-303a-8e3d-dd60c1bafba8@fastmail.fm>
 <20170817124821.GA3238792@devbig577.frc2.facebook.com>
 <559dc5fe-c162-41e6-7f14-0f3837b64585@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <559dc5fe-c162-41e6-7f14-0f3837b64585@fastmail.fm>
Sender: linux-ide-owner@vger.kernel.org
To: Bernd Schubert <BerndSchubert@fastmail.fm>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, linux-ide@vger.kernel.org, Gionatan Danti <g.danti@assyoma.it>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Aug 17, 2017 at 03:18:06PM +0200, Bernd Schubert wrote:
> So for Gionatan the root cause was an instable power supply, but in my
> case there wasn't any power loss, there were just failed sata commands.
> I'm not sure if this was a port or cable issue - once I changed port and
> sata cable the errors disappeared. I didn't change the power supply or
> power cable. I'm now basically fighting with the data corruption that
> caused - for btrfs it at least has a checksum, but I didn't have ext4
> checksum enabled, so it is hard to figure out which files are corrupts -
> silent data corruption is not well handled by backups either.

No idea there.  Retried and recovered errors shouldn't cause data
corruptions.  Flaky power can behave in unexpected ways tho.  What
happens if you hook up the drive on a different power supply but
revert to the port / cable which showed the problem?  What does your
SMART counters say across those failures?

> Is it possible that sata eh recovery sends resets to the device, which
> makes it evict its cache?

That'd be a very broken device.  It sure is theoretically possible but
I haven't seen any reports on such behaviors yet.

Thanks.

-- 
tejun
