From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 22:07:22 +0100
Message-ID: <20080729220722.7d47a948@lxorguk.ukuu.org.uk>
References: <488F524F.6020905@redhat.com>
	<20080729192126.7261318b@lxorguk.ukuu.org.uk>
	<20080729185512.GE24924@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080729185512.GE24924@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 29 Jul 2008 12:55:13 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Tue, Jul 29, 2008 at 07:21:26PM +0100, Alan Cox wrote:
> > Also early SD type devices with 256 byte sectors simply don't work with
> > our scsi midlayer.
> 
> Are any of them still spinning, or did the lubricant leak out a couple
> of decades ago?

Lubricant ? there is no lubricant in a flash card. 256 byte hard disks
probably all died years ago but early smartmedia is 256 byte/sector.
