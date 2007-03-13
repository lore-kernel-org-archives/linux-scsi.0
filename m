From: Chris Wedgwood <cw@f00f.org>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 23:34:23 -0700
Message-ID: <20070313063422.GA3801@tuatara.stupidest.org>
References: <45F48809.2060908@emc.com> <20070312000253.20eab1a3@lxorguk.ukuu.org.uk> <45F4A268.3000405@garzik.org> <20070312122424.18ed86ce@lxorguk.ukuu.org.uk> <45F56318.9030505@garzik.org> <20070313051144.GI5266@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070313051144.GI5266@schatzie.adilger.int>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Ric Wheeler <ric@emc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 13, 2007 at 01:11:44AM -0400, Andreas Dilger wrote:

> I'd guess a vast majority of IO will have the end similarly
> misaligned as the start.  Very little filesystem IO is 512 bytes,
> possibly excluding XFS in an unusual mode.

XFS (mkfs.xfs) can be told what the native sector size is and will
adjust writes accordingly.
