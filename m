From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fwd: 32bit dev_t
Date: Thu, 23 Jan 2003 22:18:05 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123221805.A2468@infradead.org>
References: <3E2DC21D.9010204@torque.net> <20030123183131.GA2126@nbkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030123183131.GA2126@nbkurt.garloff.de>; from kurt@garloff.de on Thu, Jan 23, 2003 at 07:31:31PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <kurt@garloff.de>, Douglas Gilbert <dougg@torque.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, Jan 23, 2003 at 07:31:31PM +0100, Kurt Garloff wrote:
> I'm also still waiting for the dev_t changes to port my 2.4 patches to
> support many hard disks (2k) to 2.5.
> Maybe the port should just be started now?
> Any taker? (I'm a bit short on time, so it won't happen before mid Feb
> if I have to do it myself.)

the Linux 2.5 sd and sr drivers are only limited by the number of majors
allocated to them.  There's no more architectural limit or any global
array.

