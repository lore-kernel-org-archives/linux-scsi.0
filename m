From: Matthew Wilcox <willy@debian.org>
Subject: Bug#239952: Binary-only firmware covered by the GPL?
Date: Fri, 26 Mar 2004 00:33:39 +0000
Sender: <willy@www.linux.org.uk>
Message-ID: <20040326003339.GD25059@parcelfarce.linux.theplanet.co.uk>
References: <E1B6Izr-0002Ai-00@r063144.stusta.swh.mhn.de> <20040325082949.GA3376@gondor.apana.org.au> <20040325220803.GZ16746@fs.tum.de> <40635DD9.8090809@pobox.com>
Reply-To: Matthew Wilcox <willy@debian.org>, 239952@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-bugs-rc=glddbr-debian-bugs-rc=gmane.org@lists.debian.org>
Sender: <willy@www.linux.org.uk>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.239952.B239952.10802612214489@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <40635DD9.8090809@pobox.com>
List-Post: <mailto:debian-bugs-rc@lists.debian.org>
List-Help: <mailto:debian-bugs-rc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=unsubscribe>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Adrian Bunk <bunk@fs.tum.de>, 239952@bugs.debian.org, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 25, 2004 at 05:31:53PM -0500, Jeff Garzik wrote:
> 
> Well IANAL, but it seems not so cut-n-dried, at least.
> 
> Firmware is a program that executes on another processor, so no linking 
> is taking place at all.  It is analagous to shipping a binary-only 
> program in your initrd, IMO.

Linking isn't the issue.  I went and read the original bug on this a
while back.  The issue is that it's a program that's distributed in
binary form without source code.  That's forbidden from being in main
by the terms of the Debian Social Contract.

I realise there's a grey area between "magic data you write to a device"
and "a program that is executed on a different processor".  For example,
palette data for a frame buffer.  But nobody's arguing for that grey
area here -- it's clearly a program without source code that Debian
can't distribute.

I think this is a terribly unfortunate state of affairs and I'm not happy
about how it's been handled or communicated.  I'd really appreciate it
if someone managed to think of a good solution to this.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
